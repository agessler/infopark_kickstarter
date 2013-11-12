class GoogleMapsWidget < Widget
  cms_attribute :address, type: :string

  def embed_url
    URI.escape("http://maps.google.de/maps?f=q&source=s_q&hl=de&geocode=&q=#{address}&ie=UTF8&t=m&z=14&output=embed").html_safe
  end
end
