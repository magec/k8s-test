module K8sTest
  class Result
    RESULT_TYPE = { error: 'error', ok: 'ok', already_done: 'already_done' }.freeze
    attr_reader :data

    def initialize(status:, data:)
      @status = status
      @data = data
    end

    def self.status(success, data = {})
      if success
        self.ok(data)
      else
        self.error(data)
      end
    end

    def self.ok(data = {})
      new(status: RESULT_TYPE[:ok], data: data)
    end

    def self.already_done(data = {})
      new(status: RESULT_TYPE[:already_done], data: data)
    end

    def self.error(data = {})
      new(status: RESULT_TYPE[:error], data: data)
    end

    def ok?
      @status == RESULT_TYPE[:ok]
    end

    def error?
      @status == RESULT_TYPE[:error]
    end

    def already_done?
      @status == RESULT_TYPE[:already_done]
    end
  end
end
