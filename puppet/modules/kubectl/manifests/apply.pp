define kubectl::apply(
  $content,
) {

  require kube_common::admin
  require kubectl

  $file_path = "${kube_common::yaml_dir}/${title}.yaml"

  file { $file_path:
    content => $content,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  } ~> exec { "/usr/bin/kubectl apply --kubeconfig ${kube_common::conf_dir}/admin.kubeconfig -f ${file_path}":
    refreshonly => true,
  }

}
