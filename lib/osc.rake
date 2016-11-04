require 'rake/testtask'

# Tasks
namespace :osc do
  namespace :sync do
    desc <<-END_DESC
Sync TFTP templates to TFTP server

Available options:
  * search  => REQUIRED: The search used to filter which systems to sync
  * noop    => If true, don't actually sync tftp

Example:

  rake osc:sync:tftp search='hostgroup_title = base/owens/compute'
  rake osc:sync:tftp search='name ~ owens-login01'

    END_DESC
    task tftp: :environment do
      search = ENV['search']
      noop = (ENV['noop'] && ENV['noop'] == 'true') ? true : false
      if search.empty?
        $stdout.puts "Must provide search"
        exit 1
      end

      Host.search_for(search).each do |host|
        next unless host.provision_interface.present?
        next unless host.tftp?
        print "#{host}..."
        if noop
          puts "NOOP"
          next
        end
        if host.provision_interface.rebuild_tftp
          puts "SUCCESS"
        else
          puts "FAIL"
        end
      end
    end # end tftp
  end # end sync
end
