require 'rack'
require 'capybara'
require 'capybara/dsl'
require 'capybara/session'
require 'capybara/rspec'
# require 'capybara/user_agent'
require 'pry'

# this does the file serving
class ImplictIndex
  def initialize(root)
    @root = root
    @file_server = ::Rack::File.new(root)

    res_path = ::File.join(File.dirname(__FILE__), '..', '_site')
    @res_server  = ::Rack::File.new(::File.expand_path(res_path))
  end
  attr_reader :root, :file_server, :res_server

  def call(env)
    path = env["PATH_INFO"]

    # if we are looking at / let's try index.html
    if path == "/" && exists?("index.html")
      env["PATH_INFO"] = "/index.html"
    elsif !exists?(path) && exists?(path + ".html")
      env["PATH_INFO"] += ".html"
    elsif exists?(path) && directory?(path) && exists?(File.join(path, "index.html"))
      env["PATH_INFO"] += "/index.html"
    end

    self.file_server.call(env)
  end

  def exists?(path)
    File.exist?(File.join(self.root, path))
  end

  def directory?(path)
    File.directory?(File.join(self.root, path))
  end
end

# Wire up Capybara to test again static files served by Rack
# Courtesy of http://opensoul.org/blog/archives/2010/05/11/capybaras-eating-cucumbers/

Capybara.app = Rack::Builder.new do
  map "/" do
    # use Rack::CommonLogger, $stderr
    use Rack::Lint
    run ImplictIndex.new(File.join(File.dirname(__FILE__), '..', '_site'))
  end
end.to_app

Capybara.default_selector =  :css
Capybara.default_driver   =  :rack_test
Capybara.javascript_driver = :webkit

# Capybara::UserAgent.add_user_agents(mac_browser: 'Mac/1.0')
# Capybara::UserAgent.add_user_agents(windows_browser: 'Windows/1.0')
# Capybara::UserAgent.add_user_agents(linux_browser: 'Linux/1.0')
# Capybara::UserAgent.add_user_agents(other_browser: 'Other/1.0')

RSpec.configure do |config|
  config.include Capybara::DSL
  # config.include Capybara::UserAgent::DSL
  unless File.directory?("_site")
    `jekyll build` # this takes a long time to run for each test
  end
end
