$(function() {
  $.extend(infopark, {
    linklist_field_element: {
      create_instance: function(cms_element) {
        if (cms_element.dom_element().attr('data-ip-field-type') === 'linklist') {
          return infopark.cms_field_element.create_instance(cms_element);
        }
      },

      all: function() {
        return _.map($('[data-ip-field-type="linklist"]'), function(dom_element) {
          return infopark.cms_element.from_dom_element($(dom_element));
        });
      }
    }
  });

  infopark.cms_element.definitions.push(infopark.linklist_field_element);
});
