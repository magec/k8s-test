# etcd::install
class etcd::install {

  $version = '3.4.15'
  archive { "/usr/bin/etcd-v${version}-linux-amd64.tar":
    ensure        => present,
    source        => "https://github.com/etcd-io/etcd/releases/download/v${version}/etcd-v${version}-linux-amd64.tar",
    extract_flags => "--wildcards 'etcd-v${version}-linux-amd64/etcd*' --strip-components=1 -xvf",
    extract       => true,
    extract_path  => '/usr/bin',
    creates       => '/usr/bin/etcd',
    cleanup       => true,
    user          => 'root',
    group         => 'root',
  }
}
