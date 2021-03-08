class kube_apiserver::config(
){

  $encription_key = file(project_path('/secrets/encryption.key'))
  $encryption_config = {
    kind         => "EncryptionConfig",
    apiVersion   => "v1",
    resources    => [
      {
        "resources" => [ 'secrets'],
        providers    => [
          {
            aescbc     => {
              keys => [
                {
                  "name" => key1,
                  secret => $encription_key,
                }
              ],
            },
          },
          {
            "identity" => {}
          },
        ]
      }
    ]
  }.to_yaml

  file { "${kube_common::conf_dir}/encryption-config.yaml":
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => $encryption_config
  }

}
