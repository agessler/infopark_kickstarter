class MediabrowserController < ApplicationController
  layout false

  def index
    content = render_to_string 'index'

    render json: {content: content}
  end
end
