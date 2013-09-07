class MediabrowserController < ApplicationController
  layout false

  def index
    @query = params[:query].presence || ''
    @obj_class = params[:obj_class] || 'Image'
    @selected = params[:selected] || []
    @page = (params[:page].presence || 1).to_i
    limit = (params[:limit].presence || 10).to_i
    start = (@page - 1) * limit

    @hits, @total = RailsConnector::Workspace.default.as_current do
      query = Obj.where(:_obj_class, :equals, @obj_class)
        .offset(start)
        .order(:_last_changed)
        .reverse_order

      if @query.present?
        query.and(:*, :contains_prefix, @query)
      end

      [query.take(limit), query.count]
    end

    @maxPages = (@total / limit.to_f).ceil

    render json: { content: render_to_string }
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
