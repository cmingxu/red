module ApplicationHelper
  def panel_table(title, icon, anchor = "", &block)
    content_tag(:div, class: 'panel panel-default') do
      content_tag(:div, class: 'panel-heading') do
         content_tag(:span, title, name: anchor) end +

        capture(&block) if block_given?
    end
  end

  def panel_item(title, icon, anchor = "", &block)
    content_tag(:div, class: 'panel panel-default') do
      content_tag(:div, class: 'panel-heading') do
         content_tag(:span, title, name: anchor) end +

      content_tag(:div, class: 'panel-body') do
        capture(&block) if block_given?
      end
    end
  end

  def table_classes
    %w(table table-bordered table-hover)
  end

  def btn_classes(extras = [])
    %w(btn btn-lg btn-primary).push(extras).flatten.uniq
  end

  def sm_btn_classes(extras = [])
    %w(btn btn-primary).push(extras).flatten.uniq
  end
  
  def drop_down_menu(style = :danger, display = "Actions", &block)
    id = SecureRandom.hex(10)
    content_tag(:div, class: 'dropdown') do
        content_tag(:button,  "Actions", class: "btn btn-#{style} dropdown-toggle", 'data-toggle': 'dropdown', type: 'button', 'aria-haspopup': 'true', 'aria-expanded': 'false', id: id) do
          raw(
            display + "&nbsp;&nbsp;" + 
            content_tag(:span, "", class: 'caret')
          )
        end +
      content_tag(:ul, class: 'dropdown-menu', 'aria-labelledby': id) do
        capture(&block) if block_given?
      end
    end
  end

  def drop_down_menu_item(display, link, opts = {})
    content_tag(:li) do
      link_to display, link, opts
    end
  end

  def drop_down_menu_item_sepeartor
    content_tag(:li, "", class: 'divider', role: 'seperator')
  end

  def navbar_nav_active_class(navbar)
    page_request_meta_info[:active_navbar_item] == navbar ? 'active' : ''
  end

  def need_breadcrumb
    %w(:apps_controller, :versions_controller).include?(controller_name.to_sym)  ||
      (controller_name.to_sym == :services && action_name.to_sym == :show)
  end

  def sample_data
    {
      labels: ["January", "February", "March", "April", "May", "June", "July"],
      datasets: [
        {
          label: "My First dataset",
          backgroundColor: "rgba(220,220,220,0.2)",
          borderColor: "rgba(220,220,220,1)",
          data: [65, 59, 80, 81, 56, 55, 40]
        },
        {
          label: "My Second dataset",
          backgroundColor: "rgba(151,187,205,0.2)",
          borderColor: "rgba(151,187,205,1)",
          data: [28, 48, 40, 19, 86, 27, 90]
        } ]
    }
  end

  def pie_chart_helper(labels, label, used, total)
    {
      labels: labels,
      datasets: [
        {
          label: label,
          backgroundColor: ["#FF6384", "#36A2EB"],
          borderColor: ["white"],
          data: [used, total]
        }]
    }
  end
end
