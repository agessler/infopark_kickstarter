module Footnotes
  module Notes
    class ObjClassNote < AbstractNote
      # This method always receives a controller
      #
      def initialize(controller)
        @controller = controller
        @obj = controller.instance_variable_get('@obj')
      end

      # Returns the title that represents this note.
      #
      def title
        "Object Class: #{@obj.class.name}"
      end

      # If has_fieldset? is true, create a fieldset with the value returned as legend.
      # By default, returns the title of the class (defined above).
      #
      def legend
        title
      end

      # This Note is only valid if we actually found an user
      # If it's not valid, it won't be displayed
      #
      def valid?
        @obj
      end

      # The fieldset content
      #
      def content
        name = @obj.class.name
        revision_id = RailsConnector::Workspace.current.revision_id
        endpoint = "revisions/#{revision_id}/obj_classes/#{name}"
        response = ::RailsConnector::CmsRestApi.get(endpoint)

        mount_table_for_hash(response, :summary => "Debug information for #{title}")
      end

      # Specifies in which row should appear the title.
      # The default is :show.
      #
      def row
        :infopark
      end
    end
  end
end