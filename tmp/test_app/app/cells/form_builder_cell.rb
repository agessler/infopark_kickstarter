class FormBuilderCell < Cell::Rails
  helper :cms

  # Cell actions:

  def show(presenter, obj)
    @obj = obj
    @presenter = presenter
    @custom_attributes = presenter.definition.custom_attributes

    render
  end

  # Cell states:

  def input(form, attribute)
    @form = form
    @attribute = attribute
    @type, @name, @title, @mandatory = attribute.attributes.slice('type', 'name', 'title', 'mandatory').values

    send(@type)
  end

  private

  def enum
    @collection = @attribute.attributes['valid_values']

    render(view: 'enum')
  end

  def text
    @max_length = @attribute.attributes['max_length']

    render(view: 'text')
  end

  def string
    @max_length = @attribute.attributes['max_length']

    render(view: 'string')
  end

  def multienum
    @collection = @attribute.attributes['valid_values']

    render(view: 'multienum')
  end
end
