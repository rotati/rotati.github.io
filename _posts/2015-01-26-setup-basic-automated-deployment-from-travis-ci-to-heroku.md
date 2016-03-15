---
layout: post
author: Darren
bio: Founder of Rotati and DevBootstrap. A software developer at heart who also loves spending time with his family - enjoying cycling, piano, reading and playing games with his daughter Sophia.
twitter_username: jensendarren
facebook_username: jensendarren
linkedin_username: jensendarren1
github_username: jensendarren
author_profile: http://www.tweetegy.com

title: Basic automated deployment from Travis CI to Heroku
permalink: /2015/01/basic-automated-deployment-from-travis-ci-to-heroku/
categories:
  programming
tags:
  - heroku
  - travis-ci
  - rails
  - deployment
  - ci
  - "continuous deployment"
---

### Background

It's important to get continuous feedback while an application is being developed. In today's post, lets explore the process to setup a simple, single branch, open source Git repo hosted on [Github.com](http://github.com) that needs to be deployed to [Heroku](http://heroku.com) when the build passes.

### Installations

First of all we need to install the [Heroku Toolbelt](https://toolbelt.heroku.com/) and the [Travis CI command line tool](https://github.com/travis-ci/travis.rb).

Then we need to create an account on both of these platforms. Since we are using a public repo, we can simply connect [Travis-CI.org](http://travis-ci.org) to our Github.com account directly. For Heroku, we simply need to create a new account via the [Heroku Website](http://heroku.com).

### Create and configure new Heroku application

To create a new application on Heroku, run the `heroku apps:create` command passing in your desired app name. If the app name is unavailable you will be asked to change it (usually namespacing the app name with your organization's name results in a unique app name).

{% highlight bash %}
heroku apps:create rotati-app-name
{% endhighlight %}

Since we are going to deploy a Rails application we'll need to provision the Postgres addon like so. Note that `hobby-dev` is the free Postgres addon :)

{% highlight bash %}
heroku addons:add heroku-postgresql:hobby-dev
{% endhighlight %}

Optionally, we might want to share access to this application Heroku Dashboard page with other developers (e.g. as collaborators on the project). This can be achieved using the following command:

{% highlight bash %}
heroku sharing:add username@emaildomain.com
{% endhighlight %}

That should be all we need to do now on the Heroku side now lets move onto setting up Travis CI.

### Create the travis configuation

Firstly, its necssary to 'flick the switch' for the particular repository you want Travis to watch out for and run tests against. On the page where [Travis lists all your repos](https://travis-ci.org/repositories), flick the switch to 'On' for the repo you are working with.

Next up, in our Github repo, we change directory into the project directory and run the following Travis CI command to setup a `.travis.yml` file for us:

{% highlight bash %}
touch .travis.yml
travis setup heroku
{% endhighlight %}

We need to manually specify the version of Ruby in this file too. This can be done by opening the `.travis.yml` file in a text editor and adding the language: ruby and rvm version at the top of it. Since we are using Heroku, its necessary to use a [version supported by Heroku](https://devcenter.heroku.com/articles/ruby-support#ruby-versions) (the latest version being the preferred version). At the time of writing this post this is `v2.2.0p0`.

The `.travis.yml` file should now look something like this:

{% highlight ruby %}
language: ruby
rvm:
- 2.2.0
deploy:
  provider: heroku
  api_key:
    secure: AHKXwF0xyFComYIXqOKIHbll2ExrITTs8DSMH0pD5GZrTdMRSVCr8WmAd3Xf0TBLT8xq8xWpZREbgP3m6vCGuxpRW0wKRUoeytMuS2Nr7nVjq6MFhB811D/z/BkP6l5RK/uClBgRD77dOOWDPTl0k7bCLOashazpzL+pvf0LbhI=
  app: rotati-someapp
  on:
    repo: rotati/someapp
{% endhighlight %}

In our Rails application `database.yml` file, set the `production: url` property to the value of the environemnt variable `DATABASE_URL` which we know is now configured on our server.

{% highlight ruby %}
production:
   url: <%= ENV['DATABASE_URL'] %>
{% endhighlight %}

Finally, specify the Ruby version for the application to use in Heroku and also add the `pg` gem to your Gemfile and run bundle to install it.

{% highlight ruby %}
# Inside Gemfile
ruby "2.2.0"

gem 'pg'
{% endhighlight %}

__NOTE__ the version of Ruby specified in the Gemfile must be the same as the version specified in the `.travis.yml` file above (otherwise Travis will complain!)

### Conclusion

While there are several steps to setup this CI workflow, once its done, well, its done and you will appreciate its rapid feedback and ease of use.

This process can be used to constantly review and test code as well as test drive (passing) code on a simple 'staging' server running on Heroku. Obviously there are many additional options that can be configured. One such option is deployment of an app from a specific branch as usually the `master` branch (as we are using in this demo) is reserved for Production ready code only.

For more details on configuation of Travis, check out the [Travis CI Documentation](http://docs.travis-ci.com/).




