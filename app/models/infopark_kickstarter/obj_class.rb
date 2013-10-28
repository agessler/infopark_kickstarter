module InfoparkKickstarter
  class ObjClass < Resource
    def self.namespace
      'obj_classes'
    end

    attr_accessor :id
    attr_accessor :name
    attr_accessor :type
    attr_accessor :is_active
    attr_accessor :title
    attr_accessor :attributes
    attr_accessor :mandatory_attributes
    attr_accessor :preset_attributes

    def active?
      is_active
    end

    def title?
      title.present?
    end

    def attributes
      @attributes.map do |definition|
        Attribute.new(definition)
      end
    end

    def attributes?
      attributes.present?
    end

    def mandatory_attributes?
      mandatory_attributes.present?
    end

    def preset_attributes?
      preset_attributes.present?
    end

    def count
      Rails.cache.fetch("#{self.class.cache_key(id)}_count") do
        Obj.where(:_obj_class, :equals, id).size
      end
    end
  end
end
