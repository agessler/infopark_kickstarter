class MediabrowserController < ApplicationController
  SEARCHABLE_CLASSES = ['Image', 'BlogPost']
  layout false

  def modal
    @searchable_classes = SEARCHABLE_CLASSES

    render json: { content: render_to_string }
  end

  def index
    search_string = params[:query].presence || ''
    obj_class = params[:obj_class] || SEARCHABLE_CLASSES
    @selected = params[:selected] || []
    offset = (params[:offset].presence || 0).to_i
    limit = (params[:limit] || 0).to_i

    total, hits = RailsConnector::Workspace.default.as_current do
      query = Obj.all
        .offset(offset)
        .order(:_last_changed)
        .reverse_order

      query.and(:_obj_class, :contains, obj_class) if obj_class.present?
      query.and(:*, :contains_prefix, search_string) if search_string.present?
      query.and(:id, :contains, @selected) if selected_only?

      [query.count, query.take(limit)]
    end

    object_markup = []
    hits.each do |hit|
      object_markup << {
        id: hit.id,
        content: render_to_string("/mediabrowser/thumbnails/#{hit.obj_class.underscore}", locals: {hit: hit}),
      }
    end

    render json: {
      objects: object_markup,
      meta: {
        total: total
      }
    }
  end

  def edit
    @obj = Obj.find(params[:id])

    content = begin
      render_to_string(@obj.mediabrowser_edit_view_path)
    rescue ActionView::MissingTemplate
      render_to_string('obj/edit')
    end

    render json: {
      content: content,
      meta: {
        title: @obj.name
      }
    }
  end

  protected

  def selected_only?
    params[:selected_only] == 'true'
  end
end
