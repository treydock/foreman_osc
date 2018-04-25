require 'deface'

module ForemanOsc
  class Engine < ::Rails::Engine
    engine_name 'foreman_osc'

    # config.autoload_paths += Dir["#{config.root}/app/models/concerns"]

    initializer 'foreman_osc.register_plugin', :before => :finisher_hook do |_app|
      Foreman::Plugin.register :foreman_osc do
        requires_foreman '>= 1.11'

        logger :tftp_sync, :enabled => true
      end
    end

    rake_tasks do
      load 'osc.rake'
    end

    config.to_prepare do
      begin
        # Parameter.send(:include, ForemanOsc::ParameterExtensions)
        # HostParameter.send(:include, ForemanOsc::HostParameterExtensions)
      rescue => e # rubocop:disable RescueStandardError
        Rails.logger.warn "ForemanOsc: skipping engine hook (#{e})"
      end
    end
  end
end
