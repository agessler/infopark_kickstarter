class MediabrowserController < ApplicationController
  # Return JSON responses without layout information.
  layout false

  # List of CMS object classes that are searched by the mediabrowser. For every object class a
  # filter will be displayed, to restrict the search to that object class.
  def self.searchable_object_classes
    %w(
      Image
      BlogPost
    )
  end

  # Renders the mediabrowser modal and returns it in a JSON response.
  def modal
    @searchable_classes = self.class.searchable_object_classes

    render json: { content: render_to_string }
  end

  # Renders a JSON response with a list of CMS objects that match the search query. All search
  # parameters have defaults but can be overriden by request parameters.
  def index
    search_string = params[:query].presence || ''
    obj_classes = params[:obj_classes] || self.class.searchable_object_classes
    @selected = params[:selected] || ['']
    offset = (params[:offset].presence || 0).to_i
    limit = (params[:limit].presence || 0).to_i

    query = Obj.all
      .offset(offset)
      .order(:_last_changed)
      .reverse_order

    query.and(:_obj_class, :contains, obj_classes) if obj_classes.present?
    query.and(:*, :contains_prefix, search_string) if search_string.present?
    query.and(:id, :contains, @selected) if selected_only?

    total = query.count
    hits = query.take(limit)

    objects = hits.inject([]) do |markup, hit|
      view = "/mediabrowser/thumbnails/#{hit.obj_class.underscore}"

      markup << {
        id: hit.id,
        content: render_to_string(view, locals: { hit: hit, selected: @selected.include?(hit.id) }),
      }
    end

    render json: {
      objects: objects,
      meta: {
        total: total,
      }
    }
  end

  # Render a JSON response that holds the mediabrowser inspector markup. The inspector either
  # renders the edit view for the selected object, or a fallback edit view that is located under
  # 'app/views/obj/edit'.
  def inspector
    @obj = Obj.find(params[:id])

    options = {
      layout: 'mediabrowser/inspector',
    }

    content = begin
      render_to_string(@obj.mediabrowser_edit_view_path, options)
    rescue ActionView::MissingTemplate
      render_to_string('obj/edit', options)
    end

    render json: { content: content }
  end

  private

  def selected_only?
    params[:selected_only] == 'true'
  end
end
