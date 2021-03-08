#!/usr/bin/env ruby
require "dry/cli"
require_relative 'message_helper'
require_relative 'auth_manager'
require_relative 'result'
require_relative 'utils'
require_relative 'constants'
require 'open3'

module K8sTest
  module CLI
    module Commands
      extend Dry::CLI::Registry

      class Terminal < Dry::CLI::Command
        desc 'Opens a terminal inside container'
        def call(**)
          K8sTest::AuthManager.setup_auth!
          Dir.chdir(PROJECT_DIR) do
            Bundler.with_unbundled_env do
              exec '/bin/bash'
            end
          end
        end
      end

      class Example < Dry::CLI::Command
        desc 'Runs the example'
        def call(**)
          K8sTest::AuthManager.setup_auth!
          Dir.chdir(TERRAFORM_DIR) do
            K8sTest::Utils.execute_command(
              command: "terraform init",
              not_if: Proc.new { Dir.exists?(TERRAFORM_DIR + "/.terraform") },
              message: 'Initializing terraform',
            )
            K8sTest::Utils.execute_command(
              command: "terraform apply -auto-approve",
              not_if: Proc.new { K8sTest::Utils.system('terraform plan -detailed-exitcode') },
              message: 'Creating Cloud Infrastructure',
            )
          end
          Dir.chdir(SECRETS_DIR) do
            K8sTest::Utils.execute_command(
              command: "cfssl gencert -initca #{PKI_DIR}/ca-csr.json | cfssljson -bare ca && rm ca.csr",
              not_if: Proc.new { File.exists?(SECRETS_DIR + '/ca.pem') },
              message: '(PKI) Generating CA',
            )
            %w[admin kube-proxy kube-controller-manager kube-scheduler].each do |cert|
              K8sTest::Utils.execute_command(
                command: "cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=#{PKI_DIR}/ca-config.json -profile=kubernetes #{PKI_DIR}/#{cert}-csr.json | cfssljson -bare #{cert} && rm #{cert}.csr",
                not_if: Proc.new { File.exists?(SECRETS_DIR + "/#{cert}.pem") },
                message: "(PKI) Generating #{cert} client cert",
              )
            end
            K8sTest::Utils.execute_command(
              command: "head -c 32 /dev/urandom | base64 -w0 > encryption.key",
              not_if: Proc.new { File.exists?(SECRETS_DIR + '/encryption.key') },
              message: 'Generating Encryption Key',
            )
          end
          Dir.chdir(PUPPET_DIR) do
            K8sTest::Utils.execute_command(
              command: "bolt plan run bootstrap::set_hostname --targets all",
              message: 'Setting up Hostnames',
            )
            K8sTest::Utils.execute_command(
              command: "bolt apply manifests/controller.pp --targets controllers",
              message: 'Setting up Operators',
            )
            K8sTest::Utils.execute_command(
              command: "bolt apply manifests/worker.pp --targets workers",
              message: 'Setting up Workers',
            )
          end
        end
      end

      register 'terminal', Terminal
      register 'example', Example
    end
  end
end

Dry::CLI.new(K8sTest::CLI::Commands).call
exit(0)
