module K8sTest
  class AuthManager
    HOST_ROOT='/host_root'.freeze

    class <<self
      def setup_auth!
        K8sTest::Utils.execute_command(
          command: "ssh-keygen -t rsa -b 4096 -f #{SECRETS_DIR}/id_rsa  -N \"\"",
          not_if: Proc.new { File.exists?(public_ssh_key_file) },
          message: 'Creating ssh-key pair',
        )

        K8sTest::Utils.execute_command(
          command: "ssh-add #{SECRETS_DIR}/id_rsa",
          message: 'Adding ssh-key to agent',
        )

      end

      private

      def private_ssh_key_file
        "#{SECRETS_DIR}/id_rsa"
      end

      def public_ssh_key_file
        "#{SECRETS_DIR}/id_rsa.pub"
      end

      def aws_access_key
        ENV['AWS_ACCESS_KEY_ID']
      end

      def aws_secret_key
        ENV['AWS_SECRET_ACCESS_KEY']
      end
    end
  end
end
