class LoginPageExample < ::RailsConnector::Migration
  def up
    page = create_login_page_obj
    create_reset_password_page_obj
    update_homepage_obj_class
    update_homepage_obj(page)
  end

  private

  def login_page_path
    "<%= configuration_path %>/login"
  end

  def login_page_attribute_name
    '<%= login_page_attribute_name %>'
  end

  def create_login_page_obj
    create_obj(
      _path: login_page_path,
      _obj_class: "<%= login_obj_class_name %>",
      headline: 'Login',
      show_in_navigation: 'Yes'
    )
  end

  def create_reset_password_page_obj
    create_obj(
      _path: "#{login_page_path}/reset-password",
      _obj_class: "<%= reset_password_obj_class_name %>",
      headline: 'Reset Password',
      show_in_navigation: 'Yes'
    )
  end

  def update_homepage_obj_class
    attributes = get_obj_class('Homepage')['attributes']

    login_page_link_attributes = {
      name: login_page_attribute_name,
      type: :reference,
      title: 'Login Page',
    }

    attributes << login_page_link_attributes

    update_obj_class('Homepage', attributes: attributes)
  end

  def update_homepage_obj(login_page)
    update_obj(
      Obj.find_by_path("<%= homepage_path %>").id,
      login_page_attribute_name => login_page['id'],
    )
  end
end
