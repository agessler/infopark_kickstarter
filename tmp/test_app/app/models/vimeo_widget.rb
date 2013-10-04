class VimeoWidget < Obj
  include Widget

  cms_attribute :source, type: :linklist, max_size: 1
  cms_attribute :width, type: :integer
  cms_attribute :height, type: :integer
  cms_attribute :autoplay, type: :boolean

  def embed_url
    @embed_url ||= "//player.vimeo.com/video/#{vimeo_id}"
  end

  def vimeo_id
    if url.present?
      @vimeo_id ||= url.split('/').last
    end
  end

  def url
    if source.first.present?
      @url ||= source.first.url
    end
  end
end