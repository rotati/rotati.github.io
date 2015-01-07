---
layout: post
author: darren
title: Implement a custom enumerable collection class in ruby
permalink: /2015/01/implement-a-custom-enumerable-collection-class-in-ruby
categories:
  programming
tags:
  - ruby
  - custom
  - class
  - enumerable
  - Modules
---

### Background

The [Enumerable](http://www.ruby-doc.org/core-2.1.4/Enumerable.html) module in Ruby Core is very powerful. It provides methods such as sort, min, max and others for working specifically with collections. Its implemented by collection classes such as Array out of the box but what if you need to make your own custom collection class? In this case you will need to include the Enumerable module. Here's how.

### An Enumerable Coffee Shop

Lets consider a Coffee Shop that has a number of different blends of coffee on offer. Imagine that the shop wants to sort these different blends by strength. Also consider that we may need to quickly determine the stongest or the weakest coffee. Enumerable module to the rescue!

### The item class first (Coffee Class)

First of all, lets get some coffee brewed by implementing our Coffee class!

{% highlight ruby %}
class Coffee
  attr_accessor :name
  attr_accessor :strength

  def initialize(name, strength)
    @name = name
    @strength = strength
  end
end
{% endhighlight %}

Lets make the coffee!

{% highlight ruby %}
laos = Coffee.new("Laos", 10)
angkor = Coffee.new("Angkor", 7)
nescafe = Coffee.new("Nescafe", 1)
{% endhighlight %}

Now, for starters, lets just add this to an array and try and sort it.#

{% highlight ruby %}
my_favorite_coffee = [laos, angkor, nescafe]
puts my_favorite_coffee.sort
{% endhighlight %}

This will blow up with the error <code>in `sort': comparison of Coffee with Coffee failed</code>. This is becuase the Enumerable sort method (being called on the Array instance) does not have any idea how to sort a collection of Coffee objects. In order to fix this we need to implement the _spaceship operator_ method on the Coffee class.

### The Ruby Spaceship Operator

The Ruby spaceship operator is used to compare two objects. It returns only three possible values: -1, 0, 1. It works as follows

* __Returns -1__ when the left side is __LESS__ than the right side
* __Returns 0__ when the left side is the __SAME__ as the right side
* __Returns 1__ when the left side is __GREATER__ than the right side

This simple logic is then used by the Enumerable Modules sort method.

So without further ado lets implement our own spaceship operator method for our Coffee class. In our specific case we need to sort on the _strength_ attribute.

{% highlight ruby %}
def <=>(other_coffee)
  self.strength <=> other_coffee.strength
end
{% endhighlight %}

Now if we run the program again it does not fail but it does not work so well becuase we see three Coffee object strings like this output: <code>#&lt;Coffee:0x007f9ada820f10&gt;</code>. What we really want is the human readable detail about the coffee name and strength. In order to do this we need to override the <code>to_s</code> method on the Coffee class.

Once we override the <code>to_s</code> method like so

{% highlight ruby %}
def to_s
  "<name: #{name}, strength: #{strength}>"
end
{% endhighlight %}

Then our output is now as follows, which is much better!

{% highlight ruby %}
<name: Nescafe, strength: 1>
<name: Angkor, strength: 7>
<name: Laos, strength: 10>
{% endhighlight %}

### Enter the Coffee Shop!

So now that we know we have provided enough detail to sort our Coffee objects by strength within a generic Array, we need to be able to do the same within our CoffeeShop class too. This is achieved by implementing the Enumerable module in the CoffeeShop class. There are two things we need to do in our CoffeeShop class to achive this:

1. Include the Enumerable module
2. Implement an <code>each</code> method that yields each Coffee instance to the caller

Here is our completed CoffeeShop class:

{% highlight ruby %}
class CoffeeShop
  include Enumerable
  attr_accessor :coffees

  def initialize(*coffees)
    @coffees = coffees
  end

  def each
    @coffees.map{|coffee| yield coffee}
  end
end
{% endhighlight %}

We can use it as follows and we get the same result as we do with calling sort on the Array.

{% highlight ruby %}
laos = Coffee.new("Laos", 10)
angkor = Coffee.new("Angkor", 7)
nescafe = Coffee.new("Nescafe", 1)

cs = CoffeeShop.new(nescafe, laos, angkor)
puts cs.sort
{% endhighlight %}

### Conculusion

So that is the basics of implementing Enumerable in Ruby. Here is a [Gist](https://gist.github.com/jensendarren/ee1136dd046a916c7da4) that contains the full source code.
