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
    @thumbnail_size = params[:thumbnail_size] || nil
    offset = (params[:offset].presence || 0).to_i

    @hits, total = RailsConnector::Workspace.default.as_current do
      query = Obj.all
        .offset(offset)
        .order(:_last_changed)
        .reverse_order

      query.and(:_obj_class, :contains, obj_class) if obj_class.present?
      query.and(:*, :contains_prefix, search_string) if @query.present?

      [query.take(100), query.count]
    end

    render json: {
      content: render_to_string,
      meta: {
        total: total
      }
    }
  end

  def selection
    @thumbnail_size = params[:thumbnail_size] || nil
    @selected = params[:selected] || []

    # TODO: check if the array-order is kept during find()
    @hits = Obj.find(@selected)

    render json: {
      content: render_to_string('index'),
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
end
