class Column2Widget < Widget
  cms_attribute :column_1, type: :widget
  cms_attribute :column_2, type: :widget
  cms_attribute :column_1_width, type: :string, default: '6'
  cms_attribute :column_2_width, type: :string, default: '6'
end
