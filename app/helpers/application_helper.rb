module ApplicationHelper
  def panel_item(title, icon, &block)
    content_tag(:div, class: 'panel panel-default') do
      content_tag(:div, class: 'panel-heading') do
         fa_icon(icon, text: title) end +
      content_tag(:div, class: 'panel-body') do
        capture(&block) if block_given?
      end
    end
  end

  def table_classes
    %w(table table-stripped table-hover)
  end

  def btn_classes(extras = [])
    %w(btn btn-lg btn-primary).push(extras).flatten
  end

  def sm_btn_classes(extras = [])
    %w(btn btn-primary).push(extras).flatten
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
end
