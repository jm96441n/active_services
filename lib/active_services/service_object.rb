require 'active_services/result'

module ActiveServices
  class NotImplementedError < ::StandardError; end

  class ServiceObject

    def call
      raise ActiveServices::NotImplementedError, 'You must implement the public `call` method on your service object.'
    end

    def result(model)
      Result.new(model)
    end
  end
end
