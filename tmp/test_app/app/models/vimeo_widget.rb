class VimeoWidget < Obj
  include Widget

  cms_attribute :source, type: :linklist, max_size: 1
  cms_attribute :width, type: :integer
  cms_attribute :height, type: :integer

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
      width: width,
      height: height,
    }

    json = RestClient.get("http://vimeo.com/api/oembed.json?#{params.to_param}")

    JSON.parse(json)
  rescue JSON::ParserError => error
    Rails.logger.error("Could not parse Vimeo response: #{error.message}")

    nil
  rescue RestClient::ResourceNotFound
    Rails.logger.error("Unknown vimeo url: #{source_url}")

    nil
  end
end
