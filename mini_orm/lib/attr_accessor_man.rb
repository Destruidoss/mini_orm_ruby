module AttrAccessorMan
    def my_attr_accessor(...)
        my_attr_writer(...)
        my_attr_reader(...)
    end

    def my_attr_writer(*args)
        args.each { |arg| define_method("#{arg}=") { |value|instance_variable_set("@#{arg}", value) } }
    end

    def my_attr_reader(*args)
        args.each { |arg| define_method(arg) { instance_variable_get("@#{arg}") } }
    end
end