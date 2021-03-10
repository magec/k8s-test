#!/usr/bin/env ruby
require "dry/cli"
require_relative 'message_helper'
require_relative 'auth_manager'
require_relative 'result'
require_relative 'utils'
require_relative 'constants'
require 'open3'
require 'erb'
require 'yaml'

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

      class Setup < Dry::CLI::Command
        desc 'Sets up the cluster'
        option :controllers, default: '3', desc: 'The number of controllers'
        option :workers, default: '3', desc: 'The number of workers'
        def call(**options)
          K8sTest::AuthManager.setup_auth!
          Dir.chdir(TERRAFORM_DIR) do
            K8sTest::Utils.execute_command(
              command: "terraform init",
              not_if: Proc.new { Dir.exists?(TERRAFORM_DIR + "/.terraform") },
              message: 'Initializing terraform',
            )
            K8sTest::Utils.execute_command(
              command: "terraform apply -auto-approve #{tf_vars(options)}",
              not_if: Proc.new { K8sTest::Utils.system("terraform plan -detailed-exitcode #{tf_vars(options)}") },
              message: 'Creating Cloud Infrastructure',
            )
            K8sTest::Utils.execute_command(
              command: "/usr/bin/ruby #{File.expand_path(File.join(__dir__, 'fetch_server_info.rb'))} > #{NETWORK_INFO_FILE}",
              message: 'Obtaining system information',
            )
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
          renderer = ERB.new(File.read(ADMIN_CREDS_TEMPLATE))
          admin_creds = renderer.result
          Dir.chdir(PROJECT_DIR) do
            `#{admin_creds}`
            K8sTest::Utils.execute_command(
              command: "kubectl apply -f https://storage.googleapis.com/kubernetes-the-hard-way/coredns-1.7.0.yaml",
              message: 'Setting up coreDNS',
            )
          end
          MessageHelper.done('Finished!, copy/paste this to connect get admin credentials 👇 ')
          puts admin_creds
        end
      end

      register 'terminal', Terminal
      register 'setup',  Setup
    end
  end
end

def tf_vars(options)
  "-var \"worker_nodes=#{options[:workers]}\" -var \"controller_nodes=#{options[:controllers]}\""
end

def public_address
  YAML.load(File.read(NETWORK_INFO_FILE))['network_info']['balancer_dns_name']
end

Dry::CLI.new(K8sTest::CLI::Commands).call
exit(0)
