class SlideshareWidget < Widget
  cms_attribute :source, type: :linklist

  def embed_html
    @embed_html ||= if source_url.present?
      data = embedded_information(source_url)

      data && data['html'].html_safe
    end
  end

  private

  def source_url
    @source_url ||= source.first.try(:url)
  end

  def embedded_information(slide_url)
    url = slideshare_url(slide_url)
    json = RestClient.get(url)

    JSON.parse(json)
  rescue JSON::ParserError => error
    Rails.logger.error("Could not parse Slideshare response: #{error.message}")

    nil
  rescue RestClient::ResourceNotFound
    Rails.logger.error("Unknown slideshare url: #{url}")

    nil
  end

  def slideshare_url(slide_url)
    params = {
      url: slide_url,
      format: 'json',
    }

    "http://www.slideshare.net/api/oembed/2?#{params.to_param}"
  end
end
