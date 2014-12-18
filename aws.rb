class AwsGems < FPM::Cookery::Recipe
  description 'Aws-support gems'

  name 'aws'
  version '1.0.0'
  source "nothing", :with => :noop

  platforms [:ubuntu, :debian] do
    build_depends 'libxml2-dev', 'libxslt1-dev'
    depends 'libxml2', 'libxslt1.1'
  end

  platforms [:fedora, :redhat, :centos] do
    build_depends 'libxml2-devel', 'libxslt-devel'
    depends 'libxml2', 'libxslt'
  end

  def build
    gem_install 'aws-sdk',     '1.50.0'
    gem_install 'fog',         '1.23.0'
    gem_install 'inifile',     '3.0.0'
  end

  def install
    # Do nothing!
  end

  private

  def gem_install(name, version = nil)
    v = version.nil? ? '' : "-v #{version}"
    environment.with_clean { safesystem( "#{destdir}/bin/gem install --no-ri --no-rdoc #{v} #{name}" ) }
  end

end
