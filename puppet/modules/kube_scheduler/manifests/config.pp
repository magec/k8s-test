class kube_scheduler::config(
){

  file { "${kube_common::conf_dir}/kube-scheduler.yaml":
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
    source => "puppet:///modules/${module_name}/kube-scheduler.yaml",
  }

  cert { 'kube-scheduler':
    cn        => 'system:kube-scheduler',
    path      => $kube_common::conf_dir,
    hostnames => [],
  } -> kubectl::config { "${kube_common::conf_dir}/kube-scheduler.kubeconfig":
    commands => [
      "set-cluster ${kube_common::cluster_name} --certificate-authority=${kube_common::conf_dir}/ca.pem --embed-certs=true --server=https://127.0.0.1:6443",
      "set-credentials system:kube-scheduler --client-certificate=${kube_common::conf_dir}/kube-scheduler.pem --client-key=${kube_common::conf_dir}/kube-scheduler-key.pem --embed-certs=true",
      "set-context default --cluster=${kube_common::cluster_name} --user=system:kube-scheduler",
      "use-context default"
    ]
  }

}
