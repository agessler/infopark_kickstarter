require 'spec_helper'

require 'generator_spec/test_case'
require 'generators/cms/widget/widget_generator'

describe Cms::Generators::WidgetGenerator do
  include GeneratorSpec::TestCase

  destination File.expand_path('../../../tmp/generators', __FILE__)
  arguments [
    'news_widget',
    '--title=Test News Title',
    '--icon=text',
    '--description=Test News Description',
    '--attributes=foo:html', 'bar:enum',
    '--mandatory_attributes=foo', 'bar',
    '--preset_attributes=foo:f', 'bar:b'
  ]

  before do
    prepare_destination
    run_generator
  end

  it 'generates widget' do
    destination_root.should have_structure {
      directory 'app' do
        directory 'models' do
          file 'news_widget.rb' do
            contains 'class NewsWidget < Widget'
            contains 'cms_attribute :foo, type: :html'
            contains 'cms_attribute :bar, type: :enum'
          end
        end

        directory 'widgets' do
          directory 'news_widget' do
            directory 'views' do
              file 'show.html.haml'
              file 'edit.html.haml' do
                contains 'cms_edit_label(@widget, :foo)'
                contains 'cms_edit_html(@widget, :foo)'
                contains 'cms_edit_label(@widget, :bar)'
                contains 'cms_edit_enum(@widget, :bar)'
              end
              file 'thumbnail.html.haml' do
                contains 'editing-icon-text'
              end
            end

            directory 'locales' do
              file 'en.news_widget.yml' do
                contains "title: Test News Title"
                contains "description: Test News Description"
              end
            end

            directory 'migrate' do
              migration 'create_news_widget' do
                contains "name: 'NewsWidget'"
                contains "title: 'Test News Title'"
                contains "type: 'publication'"
                contains '{:name=>"foo", :type=>"html"}'
                contains '{:name=>"bar", :type=>"enum"}'
                contains 'mandatory_attributes: ["foo", "bar"]'
                contains 'preset_attributes: {"foo"=>"f", "bar"=>"b"}'
              end
            end
          end
        end
      end
    }
  end
end
