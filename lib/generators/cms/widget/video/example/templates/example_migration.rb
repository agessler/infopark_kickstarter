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

  def add_widget(obj, attribute, widget_params)
    workspace_id = RailsConnector::Workspace.current.id
    obj_params = RailsConnector::CmsRestApi.get("workspaces/#{workspace_id}/objs/#{obj.id}")
    widget_id = RailsConnector::BasicObj.generate_widget_pool_id

    params = {}
    params['_widget_pool'] = { widget_id => widget_params }
    params[attribute] = obj_params[attribute] || {}
    params[attribute]['list'] ||= []
    params[attribute]['list'] << { widget: widget_id }

    update_obj(obj_params['id'], params)
  end
end
