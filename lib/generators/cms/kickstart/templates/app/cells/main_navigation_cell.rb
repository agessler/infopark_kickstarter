class MainNavigationCell < Cell::Rails
  helper :cms

  # Cell actions:

  cache(:show, if: :really_cache?) do |cell, page|
    [
      RailsConnector::Workspace.current.revision_id,
      page && page.homepage.id,
    ]
  end

  def show(page)
    @page = page
    @root = page.homepage

    if @root
      render
    end
  end

  # Cell states:

  def edit_toggle
    if EditModeDetection.editing_allowed?(request.env)
      render
    end
  end

  private

  def really_cache?(*args)
    RailsConnector::Workspace.current.published?
  end
end
