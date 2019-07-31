module RestDSL
  class ErrorBase < StandardError
    def initialize(message)
      message = "[RestDSL] #{message}"
      super(message)
    end
  end
  class UndefinedEnvironmentError < ErrorBase
    def initialize(environment, available_envs)
      message = "Undefined environment, #{environment}, known environments: #{available_envs.keys.join(', ')}"
      super(message)
    end
  end
end