module <%= model.pluralize.camelcase %>
  class <%= service.camelcase %> < ActiveService
    def call
      # single public method here
    end

    private
    # any other logic here
  end
end
