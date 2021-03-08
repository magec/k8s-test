class kube_common::admin {
  cert { 'admin':
    cn        => 'admin',
    path      => $kube_common::conf_dir,
    hostnames => [],
  } -> kubectl::config { "${kube_common::conf_dir}/admin.kubeconfig":
    commands => [
      "set-cluster ${kube_common::cluster_name} --certificate-authority=${kube_common::conf_dir}/ca.pem --embed-certs=true --server=https://127.0.0.1:6443",
      "set-credentials admin --client-certificate=${kube_common::conf_dir}/admin.pem --client-key=${kube_common::conf_dir}/admin-key.pem --embed-certs=true",
      "set-context default --cluster=${kube_common::cluster_name} --user=admin",
      "use-context default"
    ]
  } -> kubectl::exec { "create clusterrolebinding root-cluster-admin-binding --clusterrole=cluster-admin --user=admin":
  }
}
