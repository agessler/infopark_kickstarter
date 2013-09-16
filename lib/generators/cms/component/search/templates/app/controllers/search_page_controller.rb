class SearchPageController < CmsController
  def index
    @query = params[:q]
    limit = params[:limit] || 10
    offset = params[:offset] || 0

    @hits, @total = RailsConnector::Workspace.default.as_current do
      results = Obj.all.offset(offset)

      if @query.present?
        results.and(:*, :contains_prefix, @query)
      end

      [results.take(limit), results.count]
    end

  rescue RailsConnector::ClientError
    flash.now[:alert] = t('search.no_index')
  end
end