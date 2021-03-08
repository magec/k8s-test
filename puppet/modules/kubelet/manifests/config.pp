class kubelet::config(
){

  file { "${kube_common::conf_dir}/kubelet-config.yaml":
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template("${module_name}/kubelet-config.yaml.erb"),
  }

  cert { 'kubelet':
    cn        => 'system:kubelet',
    path      => $kube_common::conf_dir,
    hostnames => [],
  } -> kubectl::config { "${kube_common::conf_dir}/kubelet.kubeconfig":
    commands => [
      "set-cluster ${kube_common::cluster_name} --certificate-authority=${kube_common::conf_dir}/ca.pem --embed-certs=true --server=https://${kube_common::public_address}:6443",
      "set-credentials system:node --client-certificate=${kube_common::conf_dir}/kubelet.pem --client-key=${kube_common::conf_dir}/kubelet-key.pem --embed-certs=true",
      "set-context default --cluster=${kube_common::cluster_name} --user=system:node:${hostname}",
      "use-context default"
    ]
  }

}
