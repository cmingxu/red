module RepoTagsHelper
  def vuln_serverity(severity)
    case severity.downcase
    when "high"
      content_tag(:span, severity, class: 'label label-danger')
    when "medium"
      content_tag(:span, severity, class: 'label label-warning')
    when "low"
      content_tag(:span, severity, class: 'label label-primary')
    else
      severity
    end
  end
end
