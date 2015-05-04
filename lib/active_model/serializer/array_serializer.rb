module ActiveModel
  class Serializer
    class ArraySerializer
      include Enumerable
      delegate :each, to: :@objects

      attr_reader :meta, :meta_key

      def initialize(objects, options = {})
        options.merge!(root: nil)

        @objects = objects.map do |object|
          serializer_class = options.fetch(
            :serializer,
            ActiveModel::Serializer.serializer_for(object)
          )
          serializer_class.new(object, options)
        end
        @resource_name   = options[:resource_name]
        @meta            = options[:meta]
        @meta_key        = options[:meta_key]
      end

      def json_key
        @resource_name
      end

      def root=(root)
        @objects.first.root = root if @objects.first
      end
    end
  end
end
