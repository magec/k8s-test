#!/bin/bash
{
  KUBERNETES_PUBLIC_ADDRESS=18.185.216.152
  kubectl config set-cluster magec \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443

  kubectl config set-credentials admin \
    --client-certificate=admin.pem \
    --client-key=admin-key.pem

  kubectl config set-context magec \
    --cluster=magec \
    --user=admin

  kubectl config use-context magec
}
