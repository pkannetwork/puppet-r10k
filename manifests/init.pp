# This class configures r10k
class r10k (
  $remote                    = $r10k::params::remote,
  $sources                   = $r10k::params::sources,
  $cachedir                  = $r10k::params::r10k_cache_dir,
  $configfile                = $r10k::params::r10k_config_file,
  $version                   = $r10k::params::version,
  $puppet_master             = $r10k::params::puppet_master,
  $modulepath                = $r10k::params::modulepath,
  $manage_modulepath         = $r10k::params::manage_modulepath,
  $manage_ruby_dependency    = $r10k::params::manage_ruby_dependency,
  $r10k_basedir              = $r10k::params::r10k_basedir,
  $package_name              = $r10k::params::package_name,
  $provider                  = $r10k::params::provider,
  $gentoo_keywords           = $r10k::params::gentoo_keywords,
  $install_options           = $r10k::params::install_options,
  $mcollective               = $r10k::params::mcollective,
  $manage_configfile_symlink = $r10k::params::manage_configfile_symlink,
  $configfile_symlink        = $r10k::params::configfile_symlink,
  $git_settings              = $r10k::params::git_settings,
  $forge_settings            = $r10k::params::forge_settings,
  $postrun                   = undef,
  $include_prerun_command    = false,
  $include_postrun_command   = false,
  $install_gcc               = false,
) inherits r10k::params {

  # Check if user is declaring both classes
  # Other classes like r10k::webhook is supported but
  # using both classes makes no sense unless given pe_r10k
  # overrides this modules default config
  if defined(Class['pe_r10k']) {
    fail('This module does not support being declared with pe_r10k')
  }

  $ruby_dependency_options=['include','declare','ignore']
  validate_re($manage_ruby_dependency,$ruby_dependency_options)
  validate_hash($git_settings, $forge_settings)

  # TODO: Clean this up when 4.0 to require a boolean
  if $include_prerun_command == true  or $include_prerun_command == 'true'{
    include r10k::prerun_command
  }

  if $include_postrun_command == true  or $include_postrun_command == 'true'{
    include r10k::postrun_command
  }


  class { 'r10k::install':
    install_options        => $install_options,
    keywords               => $gentoo_keywords,
    manage_ruby_dependency => $manage_ruby_dependency,
    package_name           => $package_name,
    provider               => $provider,
    version                => $version,
    puppet_master          => $puppet_master,
    install_gcc            => $install_gcc,
  }

  class { 'r10k::config':
    cachedir                  => $cachedir,
    configfile                => $configfile,
    sources                   => $sources,
    modulepath                => $modulepath,
    remote                    => $remote,
    manage_modulepath         => $manage_modulepath,
    r10k_basedir              => $r10k_basedir,
    manage_configfile_symlink => $manage_configfile_symlink,
    configfile_symlink        => $configfile_symlink,
    git_settings              => $git_settings,
    forge_settings            => $forge_settings,
    postrun                   => $postrun,
  }

  if $mcollective {
    class { 'r10k::mcollective': }
  }
}
