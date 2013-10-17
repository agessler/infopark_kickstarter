class VideoWidget < Obj
  include Widget

  cms_attribute :source, type: :reference
  cms_attribute :width, type: :integer
  cms_attribute :height, type: :integer
  cms_attribute :autoplay, type: :boolean
  cms_attribute :poster, type: :reference

  # Determines the mime type of the video.
  def mime_type
    if source.present?
      source.mime_type
    end
  end
end
