module ForemanOsc
  module ParameterExtensions
    extend ActiveSupport::Concern

    included do
      after_update :sync_tftp, if: :tftp_parameter_updated?
      after_create :sync_tftp, if: :tftp_parameter?
      after_destroy :sync_tftp, if: :tftp_parameter?
    end

    def tftp_parameters
      [
        'nfsroot_host',
        'nfsroot_path',
        'nfsroot_opts',
        'nfsroot_kernel_version',
        'nfsroot_kernel',
        'nfsroot_initrd'
      ]
    end

    def sync_tftp
      Foreman::Logging.logger('foreman_osc/tftp_sync').info('HIT sync_tftp')
      if self.class.name == 'GroupParameter'
        hosts = Host::Managed.authorized.where(hostgroup: self.hostgroup.subtree_ids)
      elsif self.class.name == 'HostParameter'
        hosts = [self.host]
      else
        Foreman::Logging.logger('foreman_osc/tftp_sync').error("Don't know how to handle #{self.class.name}")
      end

      hosts.each do |host|
        if host.provision_interface.present? && host.tftp?
          if host.provision_interface.rebuild_tftp
            Foreman::Logging.logger('foreman_osc/tftp_sync').info("TFTP sync #{host}...SUCCESS")
          else
            Foreman::Logging.logger('foreman_osc/tftp_sync').info("TFTP sync #{host}...FAIL")
          end
        end
      end
    end

    def tftp_parameter_updated?
      Foreman::Logging.logger('foreman_osc/tftp_sync').info('HIT tftp_parameter_updated')
      if self.tftp_parameters.include?(self.name) && self.value_changed?
        return true
      else
        return false
      end
    end

    def tftp_parameter?
      Foreman::Logging.logger('foreman_osc/tftp_sync').info('HIT tftp_parameter')
      if self.tftp_parameters.include?(self.name)
        return true
      else
        return false
      end
    end
  end
end
