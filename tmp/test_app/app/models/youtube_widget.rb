class YoutubeWidget < Obj
  include Widget

  cms_attribute :source, type: :linklist, max_size: 1
  cms_attribute :max_width, type: :integer
  cms_attribute :max_height, type: :integer

  def embed_html
    @embed_html ||= if source_url.present?
      oembed_information && oembed_information['html'].html_safe
    end
  end

  private

  def source_url
    if source.first.present?
      @source_url ||= source.first.url
    end
  end

  def oembed_information
    params = {
      url: source_url,
      'max-width' => max_width,
      'max-height' => max_height,
      format: 'json',
    }

    json = RestClient.get("http://www.youtube.com/oembed?#{params.to_param}")

    JSON.parse(json)
  rescue JSON::ParserError => error
    Rails.logger.error("Could not parse Vimeo response: #{error.message}")

    nil
  rescue RestClient::ResourceNotFound
    Rails.logger.error("Unknown vimeo url: #{source_url}")

    nil
  end
end
