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
            # K8sTest::Utils.execute_command(
            #   command: "aws elb describe-load-balancers --load-balancer-names api |jq '.LoadBalancerDescriptions[0].DNSName",
            #   message: 'Obtaining information about the network',
            # )
          end
          Dir.chdir(SECRETS_DIR) do
            K8sTest::Utils.execute_command(
              command: "cfssl gencert -initca #{PKI_DIR}/ca-csr.json | cfssljson -bare ca && rm ca.csr",
              not_if: Proc.new { File.exists?(SECRETS_DIR + '/ca.pem') },
              message: '(PKI) Generating CA',
            )
            K8sTest::Utils.execute_command(
              command: "head -c 32 /dev/urandom | base64 -w0 > encryption.key",
              not_if: Proc.new { File.exists?(SECRETS_DIR + '/encryption.key') },
              message: 'Generating Encryption Key',
            )
          end
          Dir.chdir(PUPPET_DIR) do
            K8sTest::Utils.execute_command(
              command: "bolt puppetfile install",
              message: 'Downloading external modules of puppet into `puppet/vendor-modules`',
              not_if: Proc.new { Dir.exists?(PUPPET_DIR + '/vendor-modules/facts') },
            )
            K8sTest::Utils.execute_command(
              command: "bolt plan run bootstrap::wait_for_update --targets all",
              message: 'Waiting for the servers to be ready',
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
          K8sTest::Utils.execute_command(
              command: "",
              message: 'Creating admin credentials',
            )

        end
      end

      register 'terminal', Terminal
      register 'example',  Example
    end
  end
end

Dry::CLI.new(K8sTest::CLI::Commands).call
exit(0)
