class kube_controller_manager::config(
){

  cert { 'kube-controller-manager':
    cn        => 'system:kube-controller-manager',
    path      => $kube_common::conf_dir,
    hostnames => [],
  } -> kubectl::config { "${kube_common::conf_dir}/kube-controller-manager.kubeconfig":
    commands => [
      "set-cluster ${kube_common::cluster_name} --certificate-authority=${kube_common::conf_dir}/ca.pem --embed-certs=true --server=https://127.0.0.1:6443",
      "set-credentials system:kube-controller-manager --client-certificate=${kube_common::conf_dir}/kube-controller-manager.pem --client-key=${kube_common::conf_dir}/kube-controller-manager-key.pem --embed-certs=true",
      "set-context default --cluster=${kube_common::cluster_name} --user=system:kube-controller-manager",
      "use-context default"
    ]
  }
}
