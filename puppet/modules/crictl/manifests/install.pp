# crictl::install
class crictl::install {
  archive { '/usr/bin/crictl.tar.gz':
    ensure        => 'present',
    source        => 'https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.20.0/crictl-v1.20.0-linux-amd64.tar.gz',
    extract_flags => "-xvf",
    extract       => true,
    extract_path  => '/usr/bin',
    creates       => '/usr/bin/crictl',
    cleanup       => true,
    user          => 'root',
    group         => 'root',
  }
}
