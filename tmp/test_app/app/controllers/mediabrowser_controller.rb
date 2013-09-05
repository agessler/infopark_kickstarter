class MediabrowserController < ApplicationController
  layout false

  def index
    RailsConnector::Workspace.default.as_current do
      @images = Obj.where(:_obj_class, :equals, 'Image')
        .order(:id)
        .offset(0)
        .take(10)
    end

    content = render_to_string 'index'

    render json: { content: content }
  end

  def edit
    @obj = Obj.find(params[:id])

    content = begin
      render_to_string(@obj.mediabrowser_edit_view_path, layout: false)
    rescue ActionView::MissingTemplate => error
      render_to_string('obj/edit', layout: false)
    end

    render json: {
      content: content
    }
  end
end
