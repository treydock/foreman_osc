require 'deface'

module ForemanOsc
  class Engine < ::Rails::Engine

    initializer 'foreman_osc.register_plugin', :before => :finisher_hook do |_app|
      Foreman::Plugin.register :foreman_osc do
        requires_foreman '>= 1.11'
      end
    end

    rake_tasks do
      load 'osc.rake'
    end

  end
end
