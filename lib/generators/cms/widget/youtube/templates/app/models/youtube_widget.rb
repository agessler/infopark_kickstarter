class YoutubeWidget < Obj
  include Widget

  cms_attribute :source, type: :linklist, max_size: 1
  cms_attribute :max_width, type: :integer
  cms_attribute :max_height, type: :integer

  def embed_html
    @embed_html ||= if source_url.present?
      data = oembed_informations

      data && data['html'].html_safe
    end
  end

  def source_url
    if source.first.present?
      @source_url ||= source.first.url
    end
  end

  private

  def oembed_informations
    json = RestClient.get(oembed_url)

    JSON.parse(json)
  rescue JSON::ParserError => error
    Rails.logger.error("Could not parse Vimeo response: #{error.message}")

    nil
  rescue RestClient::ResourceNotFound
    Rails.logger.error("Unknown vimeo url: #{source_url}")

    nil
  end

  def oembed_url
    params = {
      :url => source_url,
      'max-width' => max_width,
      'max-height' => max_height,
      :format => 'json',
    }

    "http://www.youtube.com/oembed?#{params.to_param}"
  end
end