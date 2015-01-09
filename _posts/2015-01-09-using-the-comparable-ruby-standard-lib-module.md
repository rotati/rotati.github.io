---
layout: post
title: Using the OptionParser Ruby Standard Library module
permalink: /2015/01/using-the-optionparser-ruby-standard-lib-module/
categories:
  programming
tags:
  - ruby
  - custom
  - class
  - comparable
  - Modules
---

### Background

Most command line applications usually accept a variety of options that can be passed in to alter the behaviour of the application. For example, in linux, the `find` command can take a `-type d` option to specify _only search for directories_. For example the following command will find all empty directories under `~/Documents`:

{% highlight bash %}
find ~/Documents -type d -empty
{% endhighlight %}

Ruby command line applications require the same functionality and this is provided using the `OptionParser` module.

### A Basic Hello World parser class

So lets start off with a simple example - a Ruby command line application that politely says 'hello' back the user! Why not! There are several basic things we need to do to get this working:

1. Require the `OptionParser` module by using `require 'optparse'`
2. Create an empty hash to store and return our options
3. Pass a block to a new instance of `OptionParser` and calling `on` (an alias for `make_switch`) for each option we want available in our application
4. The `on` method also in turn takes a block where we can set the variable on the
hash we created earlier

So here is our first example:

{% highlight ruby %}
require 'optparse'

class HelloParser
  def self.parse(args)
    options = {}
    opts = OptionParser.new do |opts|
      opts.on('-n', '--name NAME', 'The name of the person to say hello to') do |name|
        options[:name] = name
      end
    end
    opts.parse(args)
    options
  end
end
{% endhighlight %}

This is how to use the HelloParser class in Ruby ...

{% highlight ruby %}
options = HelloParser.parse(ARGV)
puts "Hello, #{options[:name]}" if options[:name]
{% endhighlight %}

... and call the application from the command line passing in the `--name` (or `-n`) switch

{% highlight bash %}
ruby optparse_example.rb --name Darren
# Outputs:
# Hello, Darren
{% endhighlight %}

### Extending the functionality with a second switch

Lets extend this basic application by introducing a second switch `-t` which can indicate the number of times to say hello!

Notice the use of `OptionParser::OctalInteger` in the second `-t` option definition which will automatically convert the input from a `String` to a `Fixnum`

{% highlight ruby %}
class HelloParser
  def self.parse(args)
    options = {}
    opts = OptionParser.new do |opts|
      opts.on('-n', '--name NAME', 'The name of the person to say hello to') do |name|
        options[:name] = name
      end

      opts.on('-t', '--times TIMES', OptionParser::OctalInteger, 'The number of times to say hello') do |times|
        options[:times] = times
      end
    end

    opts.parse(args)
    options
  end
end
{% endhighlight %}

This is how to use the HelloParser class is now used in Ruby with the extra option. Note that we use a ternary operator to consider a default value of 1 if `-t` is not set.

{% highlight ruby %}
options = HelloParser.parse(ARGV)

repeat = options[:times].nil? ? 1 : options[:times]

if options[:name]
  repeat.times do
    puts "Hello, #{options[:name]}"
  end
end
{% endhighlight %}

This is how the application is run on the command line:

{% highlight bash %}
ruby optparse_example.rb -n Darren -t 2
# Outputs:
# Hello, Darren
# Hello, Darren
{% endhighlight %}

### Handling exceptions

Up til now we have not considered exception handling in our application. Since we are dealing with user input we should really be considering this. The location where exceptions can occor is in the `parse` method of our `OptionParser` instance so lets wrap that in a `begin..rescue` block as follows:

{% highlight ruby %}
begin
  opts.parse(args)
rescue Exception => e
  puts "Exception encountered: #{e}"
  exit 1
end
{% endhighlight %}

Now we should be good to go and our `HelloParser` will exit gracefully if there is an error.

### Conculusion

The [OptionParser module](http://ruby-doc.org/stdlib-2.2.0/libdoc/optparse/rdoc/OptionParser.html) is a great and simple way to parse parameters for Ruby command line applications. The simple DSL of `make_switch` or `on` are intuitive and self explainatory. Convertion of types at the parser level is also pretty handy. Next time I write a command line application in Ruby I will certainly use the `OptionParser` module!

Here is [Gist](https://gist.github.com/jensendarren/0311418311ae18149081) with the full example code.




