---
layout: post
author: Darren
bio: Founder of Rotati and DevBootstrap. A software developer at heart who also loves spending time with his family - enjoying cycling, piano, reading and playing games with his daughter Sophia.
twitter_username: jensendarren
facebook_username: jensendarren
linkedin_username: jensendarren1
github_username: jensendarren

title: Deployment of Elasticsearch to Amazon
permalink: /2015/09/deployment-of-elasticsearch-to-amazon/
categories:
  programming
tags:
  - elasticsearch
  - deployment
  - aws
---

### INSTALL AND SETUP ELASTICSEARCH

### Install Oracle Java

{% highlight ruby %}
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java7-installer
{% endhighlight %}

### Install the deb package for Elasticsearch:

{% highlight ruby %}
wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.5.2.deb
sudo dpkg -i elasticsearch-1.5.2.deb
{% endhighlight %}

### Open the elasticsearch config file

{% highlight ruby %}
sudo nano /etc/elasticsearch/elasticsearch.yml
{% endhighlight %}

add the following line:

{% highlight ruby %}
script.disable_dynamic: true
{% endhighlight %}

install the attachment type plugin

{% highlight ruby %}
cd /usr/share/elasticsearch
sudo bin/plugin install elasticsearch/elasticsearch-mapper-attachments/2.5.0
{% endhighlight %}

### Follow this (change numbers based on available RAM):

{% highlight ruby %}
http://blog.lavoie.sl/2012/09/configure-elasticsearch-on-a-single-host.html
{% endhighlight %}

sudo nano /etc/security/limits.conf and add:

{% highlight ruby %}
elasticsearch hard memlock 100000
{% endhighlight %}

sudo nano /etc/init.d/elasticsearch

{% highlight ruby %}
Change ES_HEAP_SIZE to 10-20% of your machine, I used 128m
Change MAX_LOCKED_MEMORY to 100000  (~100MB)
Change ES_JAVA_OPTS to "-server"
{% endhighlight %}

set the following in /etc/elasticsearch/elasticsearch.yml

{% highlight ruby %}
bootstrap.mlockall: true
{% endhighlight %}

add the following to /etc/default/elasticsearch

{% highlight ruby %}
ES_HEAP_SIZE=512m
{% endhighlight %}

add the following to ~/.bash_profile

{% highlight ruby %}
export ES_MIN_MEM=256m
export ES_MAX_MEM=800m
{% endhighlight %}

restart elasticsearch

{% highlight ruby %}
sudo service elasticsearch restart
{% endhighlight %}

Configure ElasticSearch on a single shared host by deactivating replication and limiting memory usage
