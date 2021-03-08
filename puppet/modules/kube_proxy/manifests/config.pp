class kube_proxy::config(
){

  file { "${kube_common::conf_dir}/kube-proxy-config.yaml":
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
    source => "puppet:///modules/${module_name}/kube-proxy.yaml",
  }

  cert { 'kube-proxy':
    cn        => 'system:kube-proxy',
    path      => $kube_common::conf_dir,
    hostnames => [],
  } -> kubectl::config { "${kube_common::conf_dir}/kube-proxy.kubeconfig":
    commands => [
      "set-cluster ${kube_common::cluster_name} --certificate-authority=${kube_common::conf_dir}/ca.pem --embed-certs=true --server=https://127.0.0.1:6443",
      "set-credentials system:kube-proxy --client-certificate=${kube_common::conf_dir}/kube-proxy.pem --client-key=${kube_common::conf_dir}/kube-proxy-key.pem --embed-certs=true",
      "set-context default --cluster=${kube_common::cluster_name} --user=system:kube-proxy",
      "use-context default"
    ]
  }

}
