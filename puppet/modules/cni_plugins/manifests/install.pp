# cni_plugins::install
class cni_plugins::install {

  file { ['/opt/cni', '/opt/cni/bin']:
    ensure => 'directory',
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  } ->

  archive { '/opt/cni/bin/cni_plugins.tar.gz':
    ensure        => 'present',
    source        => 'https://github.com/containernetworking/plugins/releases/download/v0.9.1/cni-plugins-linux-amd64-v0.9.1.tgz',
    extract_flags => "-xvf",
    extract       => true,
    extract_path  => '/opt/cni/bin',
    creates       => '/opt/cni/bin/sbr',
    cleanup       => true,
    user          => 'root',
    group         => 'root',
  }

}
