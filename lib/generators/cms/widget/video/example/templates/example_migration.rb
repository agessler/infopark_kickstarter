class CreateVideoWidgetExample < RailsConnector::Migration
  def up
    homepage = Obj.find_by_path("<%= example_cms_path %>")

    poster_url = 'https://ip-saas-infoparkdev-cms.s3.amazonaws.com/public/284444b2216d2bec/7e0b65a4d87d224d622a41327f07a9bd/getting-started-poster.png'
    video_url = 'https://ip-saas-infoparkdev-cms.s3.amazonaws.com/public/506c948822d39176/7d452f7d1bd716d10bcb609cbe7e3c51/getting-started.mp4'

    poster = create_obj({
      _obj_class: 'Image',
      _path: "_resources/#{SecureRandom.hex(8)}/example_poster.jpg",
      blob: upload_file(open(poster_url)),
    })

    video = create_obj({
      _obj_class: 'Video',
      _path: "_resources/#{SecureRandom.hex(8)}/example_video.jpg",
      blob: upload_file(open(video_url)),
    })

    add_widget(homepage, "<%= example_widget_attribute %>", {
      _obj_class: "<%= obj_class_name %>",
      source: video['id'],
      poster: poster['id'],
    })
  end

  private

  def add_widget(obj, attribute, widget)
    widget.reverse_merge!({
      _path: "_widgets/#{obj.id}/#{SecureRandom.hex(8)}",
    })

    widget = create_obj(widget)

    revision_id = RailsConnector::Workspace.current.revision_id
    definition = RailsConnector::CmsRestApi.get("revisions/#{revision_id}/objs/#{obj.id}")

    widgets = definition[attribute] || {}
    widgets['layout'] ||= []
    widgets['layout'] << { widget: widget['id'] }

    update_obj(definition['id'], attribute => widgets)
  end
end
