# containerd::install
class containerd::install {
  archive { '/bin/containerd.tar.gz':
    ensure        => 'present',
    source        => 'https://github.com/containerd/containerd/releases/download/v1.4.4/containerd-1.4.4-linux-amd64.tar.gz',
    extract_flags => "--strip-components=1 -xvf",
    extract       => true,
    extract_path  => '/bin',
    creates       => '/bin/containerd',
    cleanup       => true,
    user          => 'root',
    group         => 'root',
  }
}
