class Column3Widget < Widget
  cms_attribute :column_1, type: :widget
  cms_attribute :column_2, type: :widget
  cms_attribute :column_3, type: :widget
  cms_attribute :column_1_width, type: :string, default: '4'
  cms_attribute :column_2_width, type: :string, default: '4'
  cms_attribute :column_3_width, type: :string, default: '4'
end
