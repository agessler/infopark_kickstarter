# v3.2.0
  * Added Redo and Undo functionality to the Redactor html editor. (Thanks @marcelgo)
  * Bugfix: The date editor did not trigger a save operation when the date selection window was
    closed. (Thanks @gertimon)
  * Bugfix: The enum and multienum editor did not work when multiple enum cms fields were present on
    an edit view. (Thanks @gertimon)
  * A linklist editor now allows you to create, update and delete links in a CMS linklist on the
    edit view of a page or widget. The `cms_edit_linklist` helper renders the needed HTML DOM
    structure, that is handled by the `linklist_editor.js.coffee` file.
    (Thanks @cococoder and @spiderpug)
  * The video widget is now more responsive to browser size changes and adopts accordingly.
    (Thanks @gertimon and @marcelgo)
  * We implemented autosave for the redactor html editor. Every 3 seconds when the content has
    changed it is saved automatically. You can still use the "save" and "cancel" button and also use
    "ESC" to close the editor. (Thanks @marcelgo)
  * All string attributes now use a string editor on edit pages and no longer the redactor. The
    string editor is a simple input field, that handles ESC and Enter key commands. It also supports
    autosave every 3 seconds, so that your changes don't get lost.
    (Thanks @spiderpug and @marcelgo)
  * Bugfix: Generated search component now uses the new search query API instead of the deprecated
    `SearchRequest` class, which is no longer part of the Infopark Rails Connector.
    (Thanks @marcelgo)
  * Added support for page edit views. An earlier release already had built in support for
    automatically generated widget edit views and we extended it now to also support all object
    classes. Like the widget edit view, the generated edit view holds all object class attributes.

# v3.1.1
  * Bugfix: Initial migration failed on newly created projects, because the `Image` obj class
    already existed.

# v3.1.0
  * Updated to Infopark SDK (infopark_rails_connector and infopark_cloud_connector) version 6.9.4.
  * We changed the general way to create examples for certain generators. Before you could pass in
    the option `--example` and then add some other options like `--cms_path` to further configure
    the examples. We have moved all examples into their own generator, which means you can now call
    them independent from the associated generator. The example generators are called by adding
    `:example` to the generator. For example, `rails generate cms:widget:slideshare:example`.
    (Thanks @cedrics)
  * Turned fixed navbar into a normal navbar, which seems to be a more sensible default.
    (Thanks @thomasritz)
  * Added an editing icon font that is independend from the Infopark RailsConnector. This allows the
    project developer to add arbitrary project specific icons that should be used for editing views.
  * Extracted dashboard into its own gem
    [infopark_dashboard](https://github.com/infopark/infopark_dashboard).
  * Bugfix: The editmarker overlapped the save and cancel button of the redactor inplace editor.
    (Thanks @mremolt)
  * Removed deployment and code hosting rake tasks to allow free choice for these platforms.
  * Integrated the html editor "redactor" into the generated code, as it was removed from the core
    Infopark API. This allows you to more easily choose your html editor of choice. In the course
    of integrating the editor, we moved all inplace editing files into their own generator. We hope
    that this makes it easier to update this part in the future. Get more details running
    `rails generate cms:component:editing --help`.
  * Added inplace editing for CMS date attributes. (Thanks @cedrics)
  * Bugfix: Made slideshare widget more robust against invalid slideshare API responses.
  * Removed `.widget` and `.editing` CSS classes in the `show.html.haml` and `edit.html.haml` of
    widgets. They were not needed and we switched to use the public API provided by the
    RailsConnector.
  * Added a column widget generator that allows to create structure widgets that hold a certain
    number of columns, which are widget attributes again. This means you can create nested widgets
    and the editor can define the layout of a single row. The edit view of this widget allows to
    adapt the column grid width. Run `rails generate cms:widget:column --help` for more information.
  * Bugfix: The `better_errors` gem lead to segmentation faults in the test application, because it
    was loaded in `test` mode. We only load the gem in development mode now to prevent the failures.
    (Thanks @spiderpug)
  * The Kickstarter and the dashboard currently depend on Twitter Bootstrap version 2. We are
    working hard to support Twitter Bootstrap 3 in the near future.
  * The integration test application is now checked in for more convenient development of
    Kickstarter features. (Thanks @marcelgo)
  * The `add_widget` method inside of example migrations was changed, to only use the public
    RailsConnector API, instead of an API that might change in the future.
  * Remove the need for the `local.yml` configuration and instead use the `rails_connector.yml`
    and `custom_cloud.yml` provided by the console.

# v3.0.0
  * All generated widgets now have an edit view. You can access the edit view via the widget edit
    menu `Edit widget`. The edit view uses simple Ruby on Rails helper to ease the creation of
    custom edit view input fields for all different kinds of CMS attributes. The `CmsEditHelper`
    provides methods for all CMS attribute types, eventhough not all of them are yet supported for
    editing. `linklist`, and `date` attributes are only readable. The edit view also features a
    helper to create a label that is marked as required, if the attribute is required in the CMS.
  * Update `infopark_rails_connector` and `infopark_cloud_connector` to version 6.9.2.1.125136549
    and Ruby on Rails to version 3.2.14. Also other minor gem updates.
  * Bugfix: Widgets no longer create an entry in the `en.obj_class.yml` file, as they are not
    displayed in the obj class browser and therefore don't need a translation.
    (Thanks @EtectureVolkerBenders)
  * All widgets now have some new options to not only create the structure, but also an example. You
    can call `--example` and optionally `--cms_path` and `--attribute` to determine the location of
    the example widget. For example,
    `rails generate cms:widget:slider --example --cms_path=/website/en --attribute=main_content`
    creates the example on the english homepage.
  * Simplified widgets by focusing on their main functionality and making them more generally
    usable. For example, we changed the `TextWidget` to only have one html attribute, instead
    of an additional headline. But, in order to mix and match widgets more easily, we created a new
    `HeadlineWidget`. We did that for almost all widgets, which makes them more flexible.
    (Thanks @thomaswitt)
  * Removed the name of the controller in the body html tag, because we noticed that it used only on
    special pages and leads to conflicts on overview pages, for example `blog_post`.
    (Thanks @agessler)
  * Bugfix: The `redirect_link?` was still used in the redirects controller, but is no longer
    generated by the `cms_attribute` model class method, so it uses `redirect_link.present?`
    instead. (Thanks @thomasritz)
  * Renamed `HeroUnitWidget` to `TeaserWidget`, which is not so much tight to the Twitter Bootstrap
    wording and should now be more clear to editors. (Thanks @thomaswitt)
  * Renamed `BlogEntry` to `BlogPost` to adjust to the more common wording. (Thanks @thomasritz)
  * Bugfix: Kickstarter gems are now installed right after they are inserted in the Gemfile to
    prevent an error message, when running `rails g cms:kickstart`. (Thanks @dcsaszar)
  * Changed the `hero_unit` widget description to be more precise and not self referential.
    (Thanks @krishan)
  * The `developer_tools` and the `sitemap` are now part of every kickstarted project.
  * The `maps` widget is now part of the examples generated when running
    `rails generate cms:kickstart --examples`.
  * Removed the `.well` class from all widgets, as most projects removed it right away.
  * Bugfix: `Homepage` model was missing cms attribute definitions for `sort_key`, `main_content`
    and `show_in_navigation`. (Thanks @Etecture)
  * Excluded `LoginPage` and `ResetPasswordPage` from the Sitemap.
  * Bugfix: Adopt `body_attributes` helper method, to be independent from the given cms object, so
    it also works on non cms pages correctly. (Thanks @Etecture)
  * Removed unused `headline` string attribute from `Image` and `SliderWidget`.
  * Added `headline` string attribute to `SearchPage`.
  * Added notice to restart the server when generating the developer tools. (Thanks @rouvenbehnke)
  * Removed `Gemfile.lock` from version control and updated gems. (Thanks @spiderpug)

# v2.2.0
  * Updated most of the gems to the current version, eventhough we don't support Rails 4 yet.
  * Bugfix: Error page now uses a correct grid layout and displays the content correctly.
  * Removed unused footer links feature. This feature did not reflect the needs of an actual
    project. A how-to guide will be integrated in the Infopark Dev Center.
  * The developer tools (rake cms:component:developer_tools) got a new Infopark Developer Bar. This
    is an extension of the `rails-footnotes` gem and displays helpful information and links at the
    bottom of each page. (Thanks @thomasritz)
  * Insert a placeholder image in the slider widget if no images are configured. This is the case,
    when the widget is created. (Thanks @rouvenbehnke)
  * Added `--page` and `--widget` options to the model generator to allow to turn a model into a
    page or widget object via the command line. See `rails generate cms:model --help` for more
    details. (Thanks @thomasritz)
  * Added a simple breadcrumb navigation that displays pages up to the homepage on top of the page.
    Run `rails generate cms:component:breadcrumbs --help` to get further details.
    (Thanks @rouvenbehnke)
  * Refactored twitter bootstrap integration to more easily allow changes and give examples on how
    to customize the bootstrap framework.
  * Added a login widget that allows the editor to place a login form anywhere on the page. The
    login widget also holds a link to reset the password and displays a logout link and the login of
    the current user if the user is already logged in. Run `rails generate cms:widget:login --help`
    for more details. The login widgets depends on the core `login_page` component.
  * Moved login logic into a separate component to allow more flexibility and easier future
    maintainance. You can generate the login page by running
    `rails generate cms:component:login_page`. In the course thereof, support was added to reset the
    password.
  * Controls for the generic video player (flowplayer) are now enabled by default.
    (Thanks @steenkamp)
  * Moved tasks `cms:console`, `cms:status`, `cms:info:obj_classes` and `cms:info:permalinks` under
    the `infopark` namespace. You get an overview of all available rake tasks by running `rake -T`
    in your project folder.
  * Added a new rake task `infopark:info:system` to create an overview of your system that can help
    the Infopark support team to more quickly adress your issues.
  * Bugfix: The Ruby on Rails application could not handle invalid utf8 characters in the request
    url. The gem `utf8-cleaner` fixes that.
  * Bugfix: Ghost paths (an object with a missing parent) are now handled correctly when searching
    for their homepage.
  * Footer navigation refactored to highlight and reposition the company reference and add a tiny
    remark to display the platform the webpage is build on.
  * Extended footer navigation links to include link to the Dev Center User Guide.
  * Added a sitemap component that dynamically generates a sitemap.xml file.
  * Added a slideshare widget that embedds the slideshare player for a given slide url. See
    `rails generate cms:widget:slideshare --help` for more details.
  * Bugfix: The slider widget used a wrong attribute of the image link to
    display the slider headline.
  * The page title is now created dynamically as a combination of the title attribute and the
    homepage title. (Thanks @benzimmer)
  * Added a rake task `rake cms:reset` that resets the CMS completely. Please be cautious when using
    this command, as it completely wipes your CMS content and is not reversable. So use it on your
    own risk.
  * By default only "superuser" are now allowed to edit on the production website. This is due to a
    change in the WebCRM. (Thanks @Peter Mielke)
  * A fallback menu title `[no headline]` is now displayed in the menu bar, when a new object is
    created via the page menu. (Thanks @franziska-luecke)
  * Query parameters are now kept on redirects. (Thanks @thomaswitt)

# v2.1.0
  * Added the option `--examples` to the `rails generate cms:kickstart` command, that will generate
    basic components together with setting up the project. This should simplify the getting started
    process for beginners.
  * Added a hero unit widget, that displays a more visually highlighted headline and body and also
    allows to place a link button below.
  * Updated `rails generate cms:kickstart` to include the search panel in the main navigation and
  * Switched from Ruby mixins to class level attribute definition to reflect and fully support local
    cms obj class attributes. You can now define a cms attribute directly on the model using
    `cms_attribute :headline, type: :string` for example. See generated model classes for more
    examples.
  * Removed float attribute type, as it was only used in special cases and it can be easily
    integrated manually.
  * Added support for inplace navigation editing. All relevant obj classes now have a
    `thumbnail.html.haml` in their view directory that gets displayed in the obj class browser, when
    editing the main navigation.
  * It is now not longer necessary to call `rails generate rails_connector:install` before running
    `rails generate cms:kickstart`.
  * Switched from system attributes title and body to custom attributes headline and content.
  * Updated to latest Infopark RailsConnector. Moved widget view templates into `views` folder.
    Replaced workspace toggle against new menu bar and added support for toclist inplace editing and
    inplace image upload.
  * Added a form builder component that allows editors to define a form in the WebCRM. You can add
    different kinds of input types and set required fields as well. Run
    `rails generate cms:component:form_builder --help` for more information.
  * Extracted out testing setup into its own generator which is no longer part of the kickstart in
    order to decrease starting complexity. Please run `rails generate cms:component:testing` to add
    get it back. We also did this step in order to further improve and extend the functionality in
    the future, like adding integration testing or supporting different provider. (Thanks @cedrics)
  * Extracted out developer tools into its own generator which is no longer part of the kickstart in
    order to decrease dependencies. Just call `rails generate cms:component:developer_tools` if you
    want them back. `thin` gem was added to replace the default Rails webserver WEBrick.
    (Thanks @cedrics)
  * Improved introduction page, when the current working copy does not have a homepage, by switching
    to a more positive message, giving clear directions and smoothing the transition to more help
    through links in the footer.
  * Extracted the redirect functionality into its own generator which is no longer part of the
    kickstart in order to decrease complexity. Please run `rails generate cms:component:redirect` to
    get it back. (Thanks @cedrics)
  * The language switch is now generated without an example. Use
    `rails generate cms:component:language_switch --example` for the old behavior.
  * Useless, empty controller `index` actions got removed.
  * Useless spec files got removed.

# v2.0.1
  * Bugfix: Some widgets still had a sort key attribute, which is not longer needed due to the built
    in sort feature of widgets.
  * Bugfix: Widgets did not place their migrations in the widget folder.
  * Bugfix: The Dashboard crashed when global attributes were used and did not display the list of
    global attributes. (Thanks @TWT)
  * Bugfix: The Dashboard people page did not work, if no `config/deploy.yml` file was given.
  * Bugfix: The WebCRM was not initialized correctly after running `rake cms:kickstart`.
  * Bugfix: The page method of the widget concern did not return the correct page, where the widget
    was placed in.

# v2.0.0
  * Added a widget generator to create and integrate widgets of any kind. See
    `rails generate cms:widget` for more details.
  * Bugfix: Timestamped ids are now used when creating migrations.
  * Presents a nicer error page, when the choose homepage callback does not return a homepage.
  * Removed the user manager as it was way too complicated and didn't fit the more general use case.
    This lead to some refactorings of the profile, login and contact page, which should be much
    clearer now.
  * Added social sharing component, that lets you easily integrate social sharing provider to share
    the current url. (Thanks @jan-hendrik)
  * Bugfix: The workspace toggle did not always display the correct workspace title.
  * Simplified the contact page component to a more general and understandable use case. Removed
    "valid_email" dependency and user attributes prefill. The contact page is no longer placed under
    "_configuration" and linked on the homepage, but can be placed like a normal page anywhere in
    the hierarchy.
  * Bugfix: Deployment task returned an 406 error, because the url params were not formatted
    correctly.
  * Supports widgets to put their locale files into the widget directory.
  * Switched to inplace editing and the Infopark widget framework. This also removes the need for
    concrete widget examples, as they can easily be inserted on each page via the widget browser. A
    toggle is placed in the main navigation bar to switch to edit mode. (Thanks @cocodercoder)
  * Kickstarter now uses local attributes only, because global attributes are deprecated and their
    usage is discouraged. See
    [News](https://dev.infopark.net/d72e25d5cd446190/cms-attributes-are-now-local-to-object-classes)
    for further details.
  * Bugfix: Added "sort_key" to GoogleMaps Box. (Thanks @franziska-luecke)
  * Added monitoring rake task for future extension to other monitoring provider. See
    `rake cms:component:monitoring` for further details.
  * Renamed `flash_message` to `flash`, simplified and streamlined use of cells.
  * Added rake task to retrieve a list of all permalinks and their paths. See
    `rake cms:info:permalinks` for more details.
  * Search support moved into its own generator and got cleaned up and simplified. See
    `rails generate cms:component:search --help` for more details.
  * Edit-Marker no longer are included by Infopark Kickstarter, as it became a default feature of
    of Infopark RailsConnector. (Thanks @thomasritz)
  * All rake tasks now use RestClient instead of curl, for better compatibility and consistent use
    of accept headers. (Thanks @awendt)
  * Bugfix: Dashboard could not be displayed, because the engine files were not packaged in the gem.
  * Added `honeybadger` as an error tracking provider. This will also be the default from now on
    instead of `airbrake`. Run `rails generate cms:component:error_tracking --provider=honeybadger`
    to install.
  * A new slider box type was added. It slides selected images and displays there title in an
    overlay. See `rails generate cms:widget:slider --help` for more details.
  * Bugfix: Creates file `before_migrate.rb` if it doesn't exist yet. This fixes an annoyence that
    was reported several times.
  * Speed up kickstart time by grouping gem setup at the beginning. (Thanks @sethiele)
  * A new person box type was added. It allows to display a crm person with some details like her
    name and email. See `rails generate cms:widget:person --help` for more details.

# v1.0.0
  * Renamed gem from `ice_kickstarter` to `infopark_kickstarter`. Please update your `Gemfile` to
    get the latest version.
  * Added blog component to generate a basic blog with RSS and comment functionality based on the
    box framework. Call `rails generate cms:component:blog --help` to get started.
  * Added `image_url` application helper to determine the external url of an image.
  * Added rake task to check the status of the Infopark Cloud-Express Platform. Run
    `rake cms:status` to get current status information.
  * A new video box type was added. It allows to play videos from the CMS, vimeo and youtube. See
    more details running `rails generate cms:widget:video --help`.
  * Added video obj class to the kickstart generator. This allows to upload and handle videos in a
    dedicated obj class.
  * Cleaned up the composition pattern used to add common behavior to object classes. You can
    differentiate between a `Page` and a `Box` by mixing in a module in the model class.
  * Updated links to the Infopark Console to `https://console.infopark.net`.
  * Bugfix: The markup for box titles is no longer displayed, when no title exists.
  * Cleaned up and extended the composition pattern used to add common behavior to object classes.
    You can now differentiate between a `Page`, a `Box` and a `Resource`.
  * Added rake task `rake cms:console` to open the Infopark console directly from the command line.
    This introduces a new dependency on the [launchy](https://github.com/copiousfreetime/launchy)
    gem. (Thanks @thomasritz)
  * Bugfix: The CMS webservice returns `RestClient::PreconditionFailed` not
    `RestClient::InternalServerError` when asked for the Github users when there
    is no Github repository configured. (Thanks @awendt)
  * Added model generator option to set mandatory attributes. For example:
    `rails generate cms:model Foo --attributes=foo bar baz --mandatory_attributes=bar baz`.
  * Added model generator option to preset attributes. For example:
    `rails generate cms:model Foo --attributes=foo bar baz --preset_attributes=foo:f bar:b`.
  * Added attribute generator option to preset the attribute value. The default depends on the type
    of the attribute. For example, to create an integer attribute that has `10` configured as a
    default, you call `rails generate cms:attribute my_attribute --type=integer --preset_value=10`.
  * Added attribute generator option to set the name of getter method. For Example:
    `rails generate cms:attribute my_attribute --type=integer --method_name=foo`. (Thanks @cocodercoder)
  * Added support for integer and float attribute types. For example:
    `rails generate cms:attribute count --type=integer` or
    `rails generate cms:attribute latitude --type=float`.
  * Newrelic generator now sets up developer mode. (Thanks @Kieran Hayes)
  * Bugfix: Newrelic generator did not insert the correct website name in the deploy files. It also
    does not depend on the kickstart generator anymore.
  * Bugfix: Newrelic generator did not differentiate between the deploy and the api key for
    deployment notifications.
  * Bugfix: The dashboard does no longer depend on the flash messages of the
    host application.
  * Bugfix: The contact form raised an error when there was no user logged in.
  * Airbrake component now includes secure option by default and does not depend on the kickstart
    generator anymore. Also added option "--skip-deployment-notification" if you don't resolve all
    error notifications on deployment.
  * Airbrake component is now available as the default provider for the error tracking component.
    This allows to support different error tracking solutions in the future. Run
    `rails generate cms:component:error_tracking --help` to get an overview. You can still call the
    Airbrake generator directly by running `rails generate cms:component:error_tracking:airbrake`.
  * Updated contribution section in the README, which should make it easier for developers to setup
    and add features to the project.
  * Updated Infopark gems and required ```bundler >= 1.3.1``` to also work with newer
    RubyGems versions.
  * Profile Page Component: Added option to skip the import of country translations.
  * Bugfix: ```application``` javascript manifest needs to be loaded before
    ```rails_connector_after_content_tags```. (Thanks @apepper)
  * Added support for markdown attribute type. For example:
    `rails generate cms:attribute body_md --type=markdown`. (Thanks @thomasritz)

# v0.0.5
  * Renamed ```error_404``` to ```error_not_found```.
  * Moved flash messages and workspace toggle into its own cell for better
    reusability and separation of concerns.
  * Simplified cms attribute concerns for easier understanding and extensibility.
  * Added support for https S3 urls in ```obj.rb```. (Thanks @thomasritz)
  * Added Https before filter to force https in live environment. Make sure to set a hostname in
    ```app/controllers/filters/https.rb``` before deployment. (Thanks @thomasritz)
  * Bugfix: There was an UTF encoding issue in the contact page generator. (Thanks @mremolt)
  * Removed fixed versions on most of the base gems to install newest versions on project setup.
  * Removed ```rails-footnotes``` as ```better_errors``` made it superfluous in most situations.
  * Added a profile page generator that adds a link in the meta navigation when the user is logged
    in. On the profile page, the user can edit all kinds of attributes that will be saved to the web
    crm.
  * Changed default homepage to ```en``` and updated examples accordingly.
  * Updated ```less-rails-bootstrap``` to version 2.3.0 and ```rspec``` to version 2.13.0.
  * The BoxText and BoxImage widgets are now a separate generator and can therefore be called with
    ```rake cms:widget:text```. If you also want to create an example, you can add the
    ```--cms_path``` option. Both widgets are still included in the Infopark Kickstarter base
    generator.
  * Added support for boolean attribute type. It fakes a boolean by creating an enum with "Yes" and
    "No" values and provides query method in the attribute module.
  * The newrelic generator now extends the local ```custom_cloud.yml``` file, runs
    ```bundle --quiet``` because it adds a new gem and prints a notice to update the custom cloud
    platform configuration.
  * The airbrake generator now reads in the api_key from the ```custom_cloud.yml```, extends the
    local ```custom_cloud.yml``` file, runs ```bundle --quiet``` because it adds a new gem and
    prints a notice to update the custom cloud platform configuration.
  * The ```custom_cloud.yml``` is now loaded in an initializer and is available as a hash in the
    global Rails configuration as ```Rails.application.config.cloud```. The initializer is created
    in such a way, that it is loaded before the rest of the initializers are run, so that it can be
    used in the following initializers as well.
  * A new google maps box type was added. It allows to easily create a map and place pins on it.
    The new box type is part of the base Infopark Kickstarter functionality but is also
    available as a separate generator. Call ```rails generate cms:widget:google_maps --help```
    for more information.
  * Added three additional rake tasks to easily edit the cloud config file, that holds configuration
    parameters that should not be checked in to the version control system. See
    ```rake -T cms:cloud_config``` for more details on the tasks.
  * The user manager now allows to find an user by id. The remote user with this id is retrieved and
    then mapped to an application user.
  * haml-rails is not longer required by the dashboard, but only haml. This prevents the default
    rails template engine to be set for the host application. (Thanks @mremolt)
  * A website object can now be asked for all its homepages and returns a list of all Homepage
    objects.
  * A language switch allows to navigate from one language homepage to another. All languages are
    listed in the sidebar. The current language is not linked.

# v0.0.4
  * Added README information on how to create a ```deploy.yml``` file and what content it needs to
    hold.

# v0.0.3
  * Added two new rake tasks ```rake cms:info:attributes[workspace]``` which returns a list of
    attributes and their type and ```rake cms:info:obj_classes[workspace]``` which returns a list of
    object classes and their attributes. For each task the workspace can optionally be provided.
  * BoxImage now supports a link attribute, that defines if and where the displayed image is linked
    to.
  * Support for ```Redirect``` cms objects. They allow to create a navigation item, for example,
    that redirects to a different page.
  * Assets are now shared between deployments via ```before_migrate.rb``` deploy hook.
  * The body tag now holds the name of the current controller. This allows easier css scoping.
  * Included [BetterErrors](https://github.com/charliesome/better_errors) and
    [BindingOfCaller](https://github.com/banister/binding_of_caller) as core development gems. Also
    added an developer initializer file that is ignored by default.
  * The Infopark Kickstarter now depends on Ruby 1.9.3. Please make sure to upgrade your Ruby version and
    use the latest Infopark gems. We recommend to use the new hash syntax throughout the project.
  * Added authorization support to simply protect access to a page via a before filter. Use
    ```before_filter Filters::Authorization``` in your controller to protect the entire page.
  * Complete refactoring of user management. Separated application user model from its remote user
    model by introducing an application wide user manager. A default implementation is given for the
    Infopark WebCRM. This makes it possible to easily swap the user manager to LDAP for example. A
    mapper class is used for the communication between the two, possibly different, user models.
    Have a look at ```app/models/user.rb``` for how it is implemented exactly.
  * Added optional contact_page component that is connected to the WebCRM and prefills email, when
    user is logged in. Call ```rails generate cms:component:contact_page```.
  * Added Infopark Developer Dashboard mounted under ```/cms/dashboard```. The dashboard
    is only available for local requests and completely separated from your Ruby on Rails
    application.
  * Bugfix: Workspace Toggle no longer displays an empty list, when there is only one workspace.
  * Changed ```rake cms:deploy:live``` to ```rake cms:deploy``` as there is no other environment yet.
  * Added optional google analytics generator. Tracking ID and Anonymize IP Setting can
    be configured in the CMS for each homepage. Default settings can be given as generator
    options.

# v0.0.2
  * initial functionality
