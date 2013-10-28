module RailsConnector
  module CmsAttributes
    extend ActiveSupport::Concern

    module ClassMethods
      def cms_attribute(name, options = {})
        type = options[:type]

        case type
        when :string
          default = options[:default] || ''

          define_method(name) do
            self[name] || default
          end
        when :text
          default = options[:default] || ''

          define_method(name) do
            self[name] || default
          end
        when :html
          default = options[:default] || ''

          define_method(name) do
            (self[name] || default).html_safe
          end
        when :markdown
          default = options[:default] || ''

          define_method(name) do
            (self[name] || default).html_safe
          end
        when :date
          default = options[:default]

          define_method(name) do
            self[name] || default
          end
        when :enum
          default = options[:default] || ''

          define_method(name) do
            self[name] || default
          end
        when :multienum
          default = options[:default] || []

          define_method(name) do
            self[name] || default
          end
        when :integer
          default = options[:default] || 0

          define_method(name) do
            (self[name] || default).to_i
          end
        when :widget
          define_method(name) do
            nil
          end
        when :linklist
          default = options[:default] || []

          define_method(name) do
            self[name] || default
          end

          define_method("#{name}?") do
            send(name).present?
          end
        when :reference
          define_method(name) do
            self[name]
          end

          define_method("#{name}?") do
            send(name).present?
          end
        when :referencelist
          default = []

          define_method(name) do
            self[name] || default
          end

          define_method("#{name}?") do
            send(name).present?
          end
        when :boolean
          default = options[:default] || 'Yes'

          define_method(name) do
            self[name] || default
          end

          define_method("#{name}?") do
            send(name) == 'Yes'
          end
        else
          raise ArgumentError.new("Unknown cms attribute type '#{type}'.")
        end
      end
    end
  end
end
