class SearchPageController < CmsController
  def index
    @query = params[:q]
    limit = params[:limit] || 10
    offset = params[:offset] || 0

    results = Obj.all.offset(offset)

    if @query.present?
      results.and(:*, :contains_prefix, @query)
    end

    @hits = results.take(limit)
    @total = results.count
  rescue RailsConnector::ClientError
    flash.now[:alert] = t('search.no_index')
  end
end
