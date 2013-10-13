class VideoWidget < Obj
  include Widget

  cms_attribute :source, type: :linklist, max_size: 1
  cms_attribute :width, type: :integer
  cms_attribute :height, type: :integer
  cms_attribute :autoplay, type: :boolean
  cms_attribute :poster, type: :linklist, max_size: 1

  # Determines the mime type of the video.
  def mime_type
    if source.present? && source.first.internal?
      source.first.destination_object.mime_type
    end
  end
end
