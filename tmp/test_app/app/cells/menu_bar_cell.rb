class MenuBarCell < Cell::Rails
  delegate :current_user, to: :parent_controller

  def show
    if EditModeDetection.editing_allowed?(session)
      render
    end
  end

  def workspaces
    @current_workspace = RailsConnector::Workspace.current.title
    if @current_workspace
      render
    end
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
