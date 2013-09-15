class CreateImage < ::RailsConnector::Migration
  def up
    unless obj_class_exists?('Image')
      create_obj_class(
        name: 'Image',
        type: 'generic',
        title: 'Resource: Image',
        attributes: [
        ],
        preset_attributes: {},
        mandatory_attributes: []
      )
    end
  end

  private

  def obj_class_exists?(name)
    get_obj_class(name).present?
  rescue ::RailsConnector::ClientError
    false
  end
end
