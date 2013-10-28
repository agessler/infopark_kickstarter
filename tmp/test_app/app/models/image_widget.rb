class ImageWidget < Obj
  cms_attribute :source, type: :reference

  # Most CMS objects are either a page or a box. In order for them to
  # have common behavior, uncomment one of the following lines.
  # include Page
  include Widget
end