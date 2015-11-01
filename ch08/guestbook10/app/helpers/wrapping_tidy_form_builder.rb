class WrappingTidyFormBuilder < ActionView::Helpers::FormBuilder
  # To save repeating ourselves in many contexts, we can create
  # our own helper for picking countries.

  # We might want to write:
  # <div class="field">
  #   <p>
  #   <%= f.label :country %><br />
  #    <%= f.country_select :country %>
  #  </p>
  # </div>
  #
  # our country_select just calls the default select helper with the
  # choices already filled in
  def country_select(method, options={}, html_options={})
    select(method, [['Canada', 'Canada'],
                     ['Mexico', 'Mexico'],
                     ['United Kingdom', 'UK'],
                     ['United States of America', 'USA']],
                  options, html_options)
  end

  # To change the way Rails normally behaves, we need a 
   # little knowledge about how the form helpers are usually called.
   # We can get this from the Rails API documentation.
   
   # Most of the helpers have a similar signature
   
  def text_field(method, options={})
    # Helpers just return text to be included in the output
    # Here we create our label, and add it onto the front
    # of the superclass (ie. the default helper) output
    wrap_field(label = label_for(method, options) + super(method, options), options)
  end

  def text_area(method, options={})
     wrap_field(label_for(method, options) + super(method, options), options)
  end
 
  def password_field(method, options={})
    wrap_field(label_for(method, options) + super(method, options), options)
  end
   
  def file_field(method, options={})
    wrap_field(label_for(method, options) + super(method, options), options)
  end

  def date_select(method, options = {}, html_options = {})
    wrap_field(label_for(method, options) + super(method, options, html_options), options)
  end

  def select(method, choices, options = {}, html_options = {})
     wrap_field(label_for(method, options) + super(method, choices, options, html_options), options)
  end

  def time_select(method, options = {}, html_options = {})
    wrap_field(label_for(method, options) + super(method, options, html_options), options)
  end

  def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
    wrap_field(label_for(method, options) + super(method, options, checked_value, unchecked_value), options)
  end

  private

  def label_for(method, options={})
    label = label(options.delete(:label) || method)
    if options[:required]
      label.safe_concat(" <span class='required_mark'>*</span>")
    end
    label.safe_concat("<br />")
  end

  def wrap_field(text, options={})
    field_class = "field"
    if options[:required]
      field_class = "field required"
    end
    "<div class='#{field_class}'>".html_safe.safe_concat(text).safe_concat("</div>")
  end
end