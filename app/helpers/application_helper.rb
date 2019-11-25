module ApplicationHelper


  def bootstrap_status_class(status)
    status_hash = { "notice" => "info", "alert" => "danger" }
    status_hash[status].nil? ? status : status_hash[status]
  end

  def link_with_icon(icon_css, title, url, options = {})
    title_with_icon = "#{icon(*icon_css)} #{title}".html_safe
    link_to(title_with_icon, url, options)
  end
end
