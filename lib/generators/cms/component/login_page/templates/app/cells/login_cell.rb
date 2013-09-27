class LoginCell < Cell::Rails
  include Authentication
  helper :cms

  def show(page)
    @current_user = current_user
    homepage = page.homepage

    if homepage && homepage.login_page?
      @login_page = homepage.login_page

      render
    end
  end
end