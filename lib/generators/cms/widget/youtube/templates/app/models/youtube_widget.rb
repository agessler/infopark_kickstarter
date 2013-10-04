class YoutubeWidget < Obj
  include Widget

  cms_attribute :source, type: :linklist, max_size: 1
  cms_attribute :width, type: :integer
  cms_attribute :height, type: :integer

  def embed_url
    raise
    @embed_url ||= "//www.youtube.com/embed/#{youtube_id}"
  end

  def youtube_id
    if url.present?
      @youtube_id ||= url.split('v=').last
    end
  end

  def url
    if source.first.present?
      @url ||= source.first.url
    end
  end
end