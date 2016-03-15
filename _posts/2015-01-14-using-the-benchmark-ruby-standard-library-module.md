---
layout: post
author: Darren
bio: Founder of Rotati and DevBootstrap. A software developer at heart who also loves spending time with his family - enjoying cycling, piano, reading and playing games with his daughter Sophia.
twitter_username: jensendarren
facebook_username: jensendarren
linkedin_username: jensendarren1
github_username: jensendarren
author_profile: http://www.tweetegy.com

title: Using the Benchmark Ruby Standard Library module
permalink: /2015/01/using-the-benchmark-ruby-standard-library-module/
categories:
  programming
tags:
  - ruby
  - custom
  - class
  - benchmark
  - modules
  - stdlib
---

### Background

When an application grows in size it's common that it may slow down considerably in the face of heavy usage. Rather than looking at the larger picture its often best to take a microscope and look closely at the performance of the code, method by method, line by line. One tool that the Ruby Standard Library provides to assist with this is [Benchmark](http://ruby-doc.org/stdlib-2.0/libdoc/benchmark/rdoc/Benchmark.html). Lets take a quick dive into the features of the Ruby Benchmarking tool!

### Contrived Example: Compare Array Sort with Hash Sort

I say this is contrived becuase we are going to compare two methods that are essentially quite different in their implemntation. However the main point of this exercise is to get up and running with the Benchmark tool. Probably most importantly to note, is that it's not possible to directly sort a Hash and therefore `Hash#sort_by` returns a sorted Array of Arrays. Anyway, we expect to see `Hash#sort_by` on Hash to be _slower_ than `Array#sort`.

What we will do in this example is create an `Array` of 10,000 random characters and sort that. Then we will create a `Hash` with the _values_ of the `Hash` set the to exactly the same random characters. The reason we set the values to the random characters is becuase `Hash` keys must be unique and we are only using the ASCII character set and therefore we only have 255 characters to play with.

Below is the code to create our `Array` and `Hash` object:

{% highlight ruby %}
10_000.times.with_index do |i|
  ascii_code = rand(255)
  random_char = ascii_code.chr
  arr << random_char
  hash[i] = random_char
end
{% endhighlight %}

Now we have an `Array` size 10,000 (all ASCII chars, randomly inserted) and we have a `Hash` size 10,000 (with values of the same randomly generated char).

Below is a sneak peak at the new array object containing the random characters:

{% highlight ruby %}
# puts arr.take(10)
["A", "%", "\xC5", "\xE1", "G", "\xF4", "\x16", "\x81", "\x03", "+", "\xA1"]

# puts hash.first(10).to_h
{0=>"A", 1=>"%", 2=>"\xC5", 3=>"\xE1", 4=>"G", 5=>"\xF4", 6=>"\x16", 7=>"\x81", 8=>"\x03", 9=>"+"}
{% endhighlight %}

Note that the characters, altough random, are in the same order in both the `Array` and the `Hash`.

### Setting up our Benchmark harness

In order to use the `Benchmark` class we need to call the `bm` method on it passing in a block of code that we want to report on. We can run several reports in one iteration of a benchark.

As shown below we pass into the `bm` method a 'tabbed output formatting' value of 7, followed by setting up two reports with titles 'Sort Array' and 'Sort Hash'. The titles allow the developer to easily read the result once the benchmark has run.

{% highlight ruby %}
Benchmark.bm(7) do |x|
  x.report 'Sort Array' do
    arr.sort!
  end
  x.report 'Sort Hash' do
    hash.sort_by{|_key, value| value}
  end
end
{% endhighlight %}

The result is as expected that the `Hash#sort_by` method call is far slower than the `Array#sort` method call. This is due to the implentation of the `Hash#sort_by` being different to the `Array#sort` method.

The output from running this Benchmark on my machine is as follows:

{% highlight bash %}
                 user     system      total        real
Sort Array   0.010000   0.000000   0.010000 (  0.001907)
Sort Hash    0.000000   0.000000   0.000000 (  0.007687)
{% endhighlight %}

### Conclusion

In a real application, its unlikely that developers will be testing the Ruby API directly like this. Instead developers may wish to test how their code performs before after refactoring. For Rails applications, it's commen to use [NewRelic](http://newrelic.com/) as a tool to monitor performance in Production. NewRelic can help developers quickly identify areas of the codebase that are slow to run. In development the developer can isolate and performance test this code using the Ruby Benchmark tool.

As always, here is a [Gist for this Benchmark](https://gist.github.com/jensendarren/bc605c714f71f549180a)

&nbsp;
