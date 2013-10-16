module WorkspaceSelection
  extend ActiveSupport::Concern

  included do
    before_filter :select_workspace
  end

  private

  def select_workspace
    if switchable?
      switch_workspace
    elsif internal_workspace_switch?
      redirect_to_workspace('published')
    end
  end

  def switchable?
    (Rails.env.development? || EditModeDetection.editing_allowed?(request.env)) &&
      workspace_param.present?
  end

  def internal_workspace_switch?
    !Rails.env.development? &&
    !EditModeDetection.editing_allowed?(request.env) &&
    params['_rc-ws'].present? &&
    params['_rc-ws'] != 'published'
  end

  def workspace_param
    params['ws']
  end

  def switch_workspace
    workspace_id = find_workspace(workspace_param)

    if workspace_id
      redirect_to_workspace(workspace_id)
    end
  end

  def find_workspace(title_or_id)
    workspace = RailsConnector::Workspace.find(title_or_id)
    workspace.id
  rescue RailsConnector::ResourceNotFound
    workspace = workspaces.detect do |workspace|
      workspace['title'] == title_or_id
    end

    workspace && workspace['id']
  end

  def workspaces
    ::RailsConnector::CmsRestApi.get('workspaces')['results']
  end

  def redirect_to_workspace(workspace)
    query_params = request.query_parameters
    query_params.delete('ws')
    query_params.merge!('_rc-ws' => workspace)

    target = request.path + '?' + query_params.to_query

    redirect_to(target)
  end
end
