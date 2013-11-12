require 'spec_helper'

require 'generator_spec/test_case'
require 'generators/cms/widget/column/column_generator.rb'

describe Cms::Generators::Widget::ColumnGenerator do
  include GeneratorSpec::TestCase

  destination File.expand_path('../../../../tmp/generators', __FILE__)
  arguments ['--columns=3', '--max_columns=9']

  before do
    prepare_destination
  end

  describe 'with three columns' do
    before do
      run_generator ['--columns=3', '--max_columns=9', '--example']
    end

    it 'creates files' do
      destination_root.should have_structure {
        directory 'app' do
          directory 'widgets' do
            directory 'column3_widget' do
              directory 'locales' do
                file 'en.column3_widget.yml' do
                  contains 'column3_widget'
                  contains 'notice:'
                end
              end

              directory 'migrate' do
                migration 'create_column3_widget'
              end

              directory 'views' do
                file 'show.html.haml'
                file 'edit.html.haml'
                file 'thumbnail.html.haml' do
                  contains '.editing-icon-3cols'
                end
              end
            end
          end

          directory 'models' do
            file 'column3_widget.rb' do
              contains 'class Column3Widget < Widget'
              contains 'cms_attribute :column_1, type: :widget'
              contains 'cms_attribute :column_2, type: :widget'
              contains 'cms_attribute :column_3, type: :widget'
              contains 'cms_attribute :column_1_width, type: :string, default: \'3\''
              contains 'cms_attribute :column_2_width, type: :string, default: \'3\''
              contains 'cms_attribute :column_3_width, type: :string, default: \'3\''
            end
          end
        end
      }
    end
  end

  describe 'with one column' do
    before do
      run_generator ['--columns=1', '--example']
    end

    it 'uses icon-class which is not pluralized' do
      destination_root.should have_structure {
        file 'app/widgets/column1_widget/views/thumbnail.html.haml' do
          contains ".editing-icon-1col\n"
        end
      }
    end
  end
end
