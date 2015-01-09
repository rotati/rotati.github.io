---
layout: post
author: Darren
title: Using the Observable Ruby Standard Library module
permalink: /2015/01/using-the-observable-ruby-standard-lib-module/
categories:
  programming
tags:
  - ruby
  - custom
  - class
  - observable
  - modules
---

### Background

The [Observable](http://ruby-doc.org/stdlib-2.0.0/libdoc/observer/rdoc/Observable.html) module is a useful and elegant way to watch for changes in an object in Ruby. A common example is for alerting of some condition within the object being observed. The example shown in the documentation is for a `Ticker` class which has two observers: one for when the price goes _below_ a certain level and one for when the price goes _above_ a certain level. What we will do today is show something similar, but for a `CoffeeShop` class instead. Let's get to it!

### Lets observe this coffee shop

So the application that we will build will be for a coffee shop where the manager has requested that they be notified when the shop is either full or empty. We will use the Observer pattern for this task!

To get this working we need to do three things:

1. Include the `Observable` module into the `CoffeeShop` class.
2. Call `changed` when a customer enters or departs the shop.
3. Call `notify_observers`, passing any usful paramaters, whenever a customer enters or exits the shop.

### An Observable CoffeeShop class

The basic class starts with including Observable and creating an initializer method that takes the name of our shop and the capacity - that is the maximum number of customers the shop can accomodate.

{% highlight ruby %}
require 'observer'

class CoffeeShop
  include Observable

  def initialize(name, capacity)
    @name = name
    @capacity = capacity
    @customers = []
  end
end
{% endhighlight %}

### The CoffeeShop enter and depart methods

Now we need to create methods that allow a customer to enter and/or depart the shop. Notice that both methods call `changed`, then adjust the customers array accordingly and finally calls `notify_observers` on the Observable module.

{% highlight ruby %}
def enter(customer)
  changed
  @customers.push(customer)
  notify_observers(Time.now)
end

def depart(customer)
  changed
  @customers.delete(customer)
  notify_observers(Time.now)
end
{% endhighlight %}

### Create our first Observer class for the empty coffee shop alerts

Here is our first Observer. Note we pass in the instance of the class that we want the observer to observe (in this case our coffee shop instance). Then we call `add_observer` passing in `self` (that is the Observer class itself) - which essentially _registers_ the observer with the object we are interested in.

Next note the `update` method uses the instance of the coffee shop (@shop) and asks if it's empty by calling a method we have not defined yet: `empty?`. So then if the shop is indeed empty an appropriate alert will be sent to the manager.

{% highlight ruby %}
class CoffeeShopEmptyObserver
  def initialize(shop)
    @shop = shop
    @shop.add_observer(self)
  end

  def update(time)
    if @shop.empty?
      puts "#{time}: The shop is EMPTY so some staff can go home."
    end
  end
end
{% endhighlight %}

### Defining the empty? and full? methods on CoffeeShop

Since its clear that we need a method on CoffeeShop to determine if it's empty we can also define a method for if it's full as well (so that we can use that in our next observer). Here are the method definitions for `empty?` and `full?` on the `CoffeeShop` class.

{% highlight ruby %}
def full?
  @customers.count >= @capacity
end

def empty?
  @customers.count.zero?
end
{% endhighlight %}

### Create the full coffee shop observer class

Next up we need to create the `CoffeeShopFullObserver` class so that we can notify the manager to hire more staff! Here is how that looks:

{% highlight ruby %}
class CoffeeShopFullObserver
  def initialize(shop)
    @shop = shop
    @shop.add_observer(self)
  end

  def update(time)
    if @shop.full?
      puts "#{time}: The shop is FULL - quick call more staff!"
    end
  end
end
{% endhighlight %}

Note how the constructor is _exactly_ the same as the constructor in the `CoffeeShopEmptyObserver` class. We can refactor this by creating an abstract CoffeeShopObserver class like so:

{% highlight ruby %}
class CoffeeShopObserver
  def initialize(shop)
    @shop = shop
    @shop.add_observer(self)
  end
end
{% endhighlight %}

Then we can inherit our concrete observers (for empty or full states) with the new abstract `CoffeeShopObserver`. See the link at the end of this post for the complete source code.

### Usage

So lets get this application up and running and open up our coffee shop and let the customers in (and out!).

First we need to create an instance of our `CoffeeShop` class and pass that onto both observers like so:

{% highlight ruby %}
coffee_shop = CoffeeShop.new("Costa", 3)
CoffeeShopEmptyObserver.new(coffee_shop)
CoffeeShopFullObserver.new(coffee_shop)
{% endhighlight %}

For basic usage we can manually assign some customers to enter or depart the shop like so:

{% highlight ruby %}
coffee_shop.enter("Darren")
coffee_shop.enter("Brian")
coffee_shop.enter("Tammy") #will trigger the alert from the 'full' observer (capacity is set to 3)
coffee_shop.depart("Darren")
coffee_shop.depart("Brian")
coffee_shop.depart("Tammy") #will trigger the alert from the 'empty' observer
{% endhighlight %}

### Conclusion

The observer pattern as implemented in the Ruby Standard Library is pretty powerful and yet very easy to use. One can imagine using this in a real world application where instead of `puts` one might send out an sms alert or an email to a real manager.

Here is a [Gist](https://gist.github.com/jensendarren/e49c60596b7c7268e605) containing the full source code with some extra stuff for randomly generating customers to come and go as they please thus producing a typical ebb and flow of activity in our cool coffee shop!
