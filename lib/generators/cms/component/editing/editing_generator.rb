module Cms
  module Generators
    module Component
      class EditingGenerator < ::Rails::Generators::Base
        source_root File.expand_path('../templates', __FILE__)

        SUPPORTED_EDITORS = %w(redactor)

        class_option :editor,
          type: :string,
          default: SUPPORTED_EDITORS.first,
          desc: "Select what html editor to use. (#{SUPPORTED_EDITORS.join(' | ')})"

        def validate_editor
          unless SUPPORTED_EDITORS.include?(editor)
            puts 'Please choose a supported editor. See options for more details.'
            puts

            self.class.help(self)

            exit
          end
        end

        def install_gems
          gem_group(:assets) do
            gem('bootstrap-datepicker-rails')
            gem('jquery-ui-rails')
          end

          Bundler.with_clean_env do
            run('bundle --quiet')
          end
        end

        def create_common_files
          directory('app')
        end

        def update_application_js
          file = 'app/assets/javascripts/application.js'
          insert_point = "//= require infopark_rails_connector"

          data = []

          data << ''
          data << '//= require editors/string_editor'
          data << '//= require editors/linklist_editor'
          data << '//= require editing'
          data << '//= require jquery.ui.sortable'

          data = data.join("\n")

          insert_into_file(file, data, after: insert_point)
        end

        def update_application_css
          file = 'app/assets/stylesheets/application.css'
          insert_point = '*= require infopark_rails_connector'

          data = []
          data << ''
          data << ' *= require editors/string_editor'
          data << ' *= require editors/linklist_editor'
          data << ' *= require editing'
          data << ' *= require bootstrap-datepicker'

          data = data.join("\n")

          insert_into_file(file, data, after: insert_point)
        end

        def run_generator_for_selected_editor
          Rails::Generators.invoke("cms:component:editing:#{editor}", [], behavior: behavior)
        end

        private

        def editor
          options[:editor]
        end
      end
    end
  end
end
