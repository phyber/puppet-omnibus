class PuppetOmnibus < FPM::Cookery::Recipe
  homepage 'https://github.com/scalefactory/puppet-omnibus'

  section 'Utilities'
  name 'scalefactory'
  version '3.7.3'
  description 'Puppet Omnibus package'
  vendor 'fpm'
  maintainer '<jon@scalefactory.com>'
  license 'Various'

  automation_packages = [
    'automation-hiera', 'automation-rubygems', 'automation-rubygem-right_http_connection',
    'automation-ruby-augeas', 'automation-hiera-gpg', 'automation-mcollective',
    'automation-ruby', 'automation-facter', 'automation-ruby-rdoc', 'automation-rubygem-flexmock',
    'automation-rubygem-right_aws', 'automation-hiera-aws', 'automation-rubygem-json',
    'automation-mcollective-common', 'automation-rubygem-SyslogLogger', 'automation-ruby-libs',
    'automation-ruby-irb', 'automation-ruby-shadow', 'automation-puppet', 'automation-rubygems',
  ]

  automation_debian = [
    'automation-libruby', 'automation-augeas-lenses', 'automation-libaugeas0',
    'automation-libaugeas-ruby1.8', 'automation-ruby-stomp', 'automation-libruby1.8',
    'automation-libshadow-ruby1.8', 'automation-puppet-common', 'automation-ruby1.8',
    'automation-ruby-gpgme', 'automation-ruby-hiera', 'automation-ruby-hiera-gpg',
    'automation-ruby-hiera-puppet', 'automation-ruby-json', 'automation-ruby-stomp',
    'automation-ruby-zcollective', 'automation-ruby-netaddr',
  ]

  automation_redhat = [
    'automation-ruby(abi) = 2.0', 'automation-ruby(x86-64)', '/opt/automation/usr/bin/ruby',
    'automation-rubygem-rack', 'automation-rubygem-rake', 'automation-mcollective-client',
    'automation-hiera-puppet', 'automation-rubygem-gpgme', 'automation-rubygem-stomp',
    'automation-rubygem-sf-deploy', 'automation-rubygem-zcollective', 'automation-rubygem-netaddr',
  ]

  platforms [:ubuntu, :debian] do
    provides [ automation_packages, automation_debian ].flatten
    conflicts [ automation_packages, automation_debian ].flatten
    replaces [ automation_packages, automation_debian ].flatten
  end

  platforms [:fedora, :redhat, :centos] do
    replaces [ automation_packages, automation_redhat ].flatten
    provides [ automation_packages, automation_redhat ].flatten
  end

  source '', :with => :noop

  omnibus_package true
  omnibus_dir     "/opt/#{name}"
  omnibus_recipes 'libyaml',
                  'ruby',
                  'mcollective',
                  'puppet',
                  'aws'


  if ENV.has_key?('PKG_VERSION')
    revision ENV['PKG_VERSION']
  else
    puts "Using revision number 0, as no PKG_VERSION passed - this may not be correct"
    revision 0
  end

  # Set up paths to initscript and config files per platform
  platforms [:ubuntu, :debian] do
    config_files '/etc/puppet/puppet.conf',
                 '/etc/init.d/puppet',
                 '/etc/default/puppet',
                 '/etc/default/mcollective',
                 '/etc/mcollective/server.cfg',
                 '/etc/mcollective/client.cfg'
  end
  platforms [:fedora, :redhat, :centos] do
    config_files '/etc/puppet/puppet.conf',
                 '/etc/init.d/puppet',
                 '/etc/sysconfig/puppet',
                 '/etc/sysconfig/mcollective',
                 '/etc/mcollective/server.cfg',
                 '/etc/mcollective/client.cfg'
  end

  omnibus_additional_paths config_files, '/var/lib/puppet/ssl/certs',
                                         '/var/lib/puppet/state',
                                         '/var/run/puppet',
                                         '/etc/mcollective/plugin.d',
                                         '/etc/mcollective/ssl/clients',
                                         '/etc/init.d/mcollective',
                                         '/etc/facter/facts.d'

  def build
    # Nothing
  end

  def install
    # Set paths to package scripts
    self.class.post_install builddir('post-install')
    self.class.pre_uninstall builddir('pre-uninstall')
    self.class.post_uninstall builddir('post-uninstall')
  end

end

