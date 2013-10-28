require 'spec_helper'

require 'generator_spec/test_case'
require 'generators/cms/component/tracking/google_analytics/google_analytics_generator.rb'

describe Cms::Generators::Component::Tracking::GoogleAnalyticsGenerator do
  include GeneratorSpec::TestCase

  destination File.expand_path('../../../../../tmp/generators', __FILE__)
  arguments []

  before do
    prepare_destination
    prepare_environments
    run_generator
  end

  def prepare_environments
    layouts_path = "#{destination_root}/app/views/layouts"

    mkdir_p(layouts_path)

    File.open("#{layouts_path}/application.html.haml", 'w') { |file| file.write("    = javascript_include_tag('editing') if inplace_editing_allowed?") }
  end

  it 'creates files' do
    destination_root.should have_structure {
      directory 'app' do
        directory 'cells' do
          file 'google_analytics_cell.rb'

          directory 'google_analytics' do
            file 'javascript.html.haml'
            file 'anonymize.js.haml'
            file 'tracking_id.js.haml'
          end
        end

        directory 'views' do
          directory 'layouts' do
            file 'application.html.haml' do
              contains "    = render_cell(:google_analytics, :javascript, 'UA-xxxxxx-x', true)"
            end
          end
        end
      end
    }
  end
end
