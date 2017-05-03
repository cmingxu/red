module ApplicationHelper
  def panel_item(title, icon, &block)
    content_tag(:div, class: 'panel panel-default') do
      content_tag(:div, class: 'panel-heading') do
         fa_icon(icon, text: title)
      end +
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
end
