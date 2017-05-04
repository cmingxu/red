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

#<div class="btn-group">
  #<button type="button" class="btn btn-danger">Action</button>
  #<button type="button" class="btn btn-danger dropdown-toggle dropdown-toggle-split" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
    #<span class="sr-only">Toggle Dropdown</span>
  #</button>
  #<div class="dropdown-menu">
    #<a class="dropdown-item" href="#">Action</a>
    #<a class="dropdown-item" href="#">Another action</a>
    #<a class="dropdown-item" href="#">Something else here</a>
    #<div class="dropdown-divider"></div>
    #<a class="dropdown-item" href="#">Separated link</a>
  #</div>
#</div>
  
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
end
