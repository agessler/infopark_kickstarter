class MenuBarCell < Cell::Rails
  delegate :current_user, to: :parent_controller

  # Cell actions:

  def show
    if EditModeDetection.editing_allowed?(request.env)
      render
    end
  end

  # Cell states:

  def workspaces
    @title = if RailsConnector::Workspace.current.title
      I18n.t('editing.workspace.working_copy', title: RailsConnector::Workspace.current.title)
    else
      I18n.t('editing.workspace.published_content')
    end

    render
  end

  def user
    if current_user.logged_in?
      @user_name = current_user.full_name

      render
    end
  end

  def edit_toggle
    render
  end
end
