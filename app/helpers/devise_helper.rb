module DeviseHelper
  def devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:p, msg) }.join
    html = "<div class=\"error_explanation\">\n<p>\n#{messages}</p>\n</div>\n"
    html.html_safe
  end
end
