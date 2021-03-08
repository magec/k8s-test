module K8sTest
  class Utils
    class <<self
      def system(command)
        Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
          wait_thr.join
          File.write(STDOUT_FILE, stdout.read, mode: 'a')
          File.write(STDERR_FILE, stderr.read, mode: 'a')

          return wait_thr.value.success?
        end
      end

      def execute_command(command:, not_if: Proc.new { nil }, message:, env_vars: {} )
        MessageHelper.do_or_done(message: message) do
          if not_if.call
            K8sTest::Result.already_done
          else
            Open3.popen3(env_vars, command) do |stdin, stdout, stderr, wait_thr|

              wait_thr.join
              File.write(STDOUT_FILE, stdout.read, mode: 'a')
              File.write(STDERR_FILE, stderr.read, mode: 'a')

              K8sTest::Result.status(wait_thr.value)
            end
          end
        end
      end
    end
  end
end
