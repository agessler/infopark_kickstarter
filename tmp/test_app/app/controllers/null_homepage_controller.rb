# This file is only used to display an introduction page, in case the current
# working copy does not return a valid homepage object. Usually, you can delete
# this file safely once you first published your content. See
# "app/models/null_homepage" and "config/initializers/rails_connector.rb" as well.
class NullHomepageController < CmsController
  def index
    render(layout: true, inline: '
      <div style="text-align: center;">
        <h1 style="font-size: 100px; line-height: 1;">Infopark Platform. Up and Running.</h1>
        <p style="font-size: 24px; line-height: 1.25;">Usually, here you would see your published
          content, for example your homepage or content page, but right now all your changes are made
          in a working copy. Think of it as a duplicate of your content, where you can edit and test
          everything before publishing it.
        </p>
        <hr />
        <p style="font-size: 24px; line-height: 1.25;">Ready to play with <strong>widgets</strong>,
          drop in <strong>images</strong>, add <strong>pages</strong> and <strong>explore</strong>
          your project?</p><p><a class="btn btn-success btn-lg" href="/?ws=rtc" style="font-size:
          21px; padding: 14px 24px;">Start Editing Now</a>
        </p>
      </div>'
    )
  end

  def self.use_for_obj_dispatch?
    true
  end
end
