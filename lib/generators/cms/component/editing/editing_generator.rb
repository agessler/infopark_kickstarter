module Cms
  module Generators
    module Component
      class EditingGenerator < ::Rails::Generators::Base
        include Actions

        source_root File.expand_path('../templates', __FILE__)

        SUPPORTED_EDITORS = %w(redactor)

        class_option :editor,
          type: :string,
          default: SUPPORTED_EDITORS.first,
          desc: "Select what html editor to use. (#{SUPPORTED_EDITORS.join(' | ')})"

        def add_routes
          route "get 'mediabrowser', to: 'mediabrowser#index'"
          route "get 'mediabrowser/inspector', to: 'mediabrowser#inspector'"
          route "get 'mediabrowser/modal', to: 'mediabrowser#modal'"
        end

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

        def add_javascript_directives
          data = []

          data << ''
          data << '//= require jquery.ui.sortable'
          data << '//= require bootstrap-datepicker'

          data = data.join("\n")

          update_javascript_editing_manifest(data)
        end

        def add_stylesheet_manifest
          data = []

          data << ''
          data << ' *= require bootstrap-datepicker'

          data = data.join("\n")

          update_stylesheet_editing_manifest(data)
        end

        def update_production_environment
          data = []

          data << '# Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)'
          data << '  config.assets.precompile += %w(editing.css editing.js)'
          data << ''

          data = data.join("\n")

          environment(data, env: :production)

          log(:environment, 'production: config.assets.precompile += %w(editing.css editing.js)')
        end

        def add_menu_bar_to_layout
          file = 'app/views/layouts/application.html.haml'
          insert_point = '%body{body_attributes(@obj)}'

          data = "\n    = render_cell(:menu_bar, :show)"

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
