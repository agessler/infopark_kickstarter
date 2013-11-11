class SocialSharingCell < Cell::Rails
  SUPPORTED_PROVIDER = [:facebook, :google, :twitter, :linkedin]

  # Cell actions:

  def show(url = nil, provider = SUPPORTED_PROVIDER)
    @url = url
    @provider = provider

    render
  end

  # Cell states:
  # The following states assume @url to be given.

  def facebook
    @locale = 'en_US'
    @data = {
      href: @url,
      send: 'false',
      layout: 'button_count',
      show: {
        faces: 'false',
      },
    }

    render
  end

  def google
    @locale = 'en_US'

    render
  end

  def twitter
    render
  end

  def linkedin
    render
  end
end
