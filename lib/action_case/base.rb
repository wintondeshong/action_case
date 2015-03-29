module ActionCase
  class Base

    attr_accessor :listener

    def initialize(listener = nil)
      @listener = listener
    end

    def resource
      raise "ActionCase::Base#resource must be overridden"
    end


    #####################################

    protected

    #####################################

    def get_explicit_handler(method_name, is_success: true)
      class_name = self.class.name.underscore.split("/").last # accounts for namespaces
      "#{class_name}_#{method_name}_#{is_success ? "success" : "error"}"
    end

    def get_generic_handler(method_name, is_success: true)
      "#{method_name}_#{is_success ? "success" : "error"}"
    end

    def get_options_value(options, attr_sym)
      lower_camelized_attr = attr_sym.to_s.camelize(:lower).to_sym

      if options[attr_sym]
        options[attr_sym]
      elsif options[lower_camelized_attr]
        options[lower_camelized_attr]
      else
        nil
      end
    end

    def respond(response, is_success = true)
      return response if @listener.nil?

      caller_name           = caller_locations(1,1)[0].label
      generic_handler_name  = get_generic_handler(caller_name,  is_success: is_success)
      explicit_handler_name = get_explicit_handler(caller_name, is_success: is_success)

      if @listener.respond_to?(explicit_handler_name)
        @listener.send explicit_handler_name, response
      elsif @listener.respond_to?(generic_handler_name)
        @listener.send generic_handler_name, response
      else
        response
      end
    end

  end
end
