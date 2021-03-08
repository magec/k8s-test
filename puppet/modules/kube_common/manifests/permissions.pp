class kube_common::permissions {
  kubectl::apply { 'cluster-role-apiserver-kubelet':
    content => file(project_path('yaml/apiserver_to_kubelet.yaml')),
  }
}
