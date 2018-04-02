module ActiveServices
  class Result
    attr_reader :model

    def initialize(model)
      @model = model
    end

    def errors
      @model.errors.full_messages
    end

    def success?
      errors.empty?
    end
  end
end
