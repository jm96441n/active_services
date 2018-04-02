module ActiveServices
  class Result
    attr_reader :model, :errors

    def initialize(model)
      @model = model
      @errors = @model.errors.full_messages
    end

    def success?
      @errors.empty?
    end
  end
end
