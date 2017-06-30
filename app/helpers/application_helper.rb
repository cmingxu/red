module ApplicationHelper
  def io_icon icon, classes = ""
    content_tag(:i, " ", class: "ion ion-#{icon}")
  end

  def panel_table(title, icon, anchor = "", style = 'default', &block)
    content_tag(:div, class: "panel panel-#{style}") do
      content_tag(:div, class: 'panel-heading') do
         content_tag(:span, fa_icon(icon, class: 'primary') + " " +  title, name: anchor) end +

        capture(&block) if block_given?
    end
  end

  def panel_item(title, icon, anchor = "", style = 'default', &block)
    content_tag(:div, class: "panel panel-#{style}") do
      content_tag(:div, class: 'panel-heading') do
         content_tag(:span, fa_icon(icon, class: 'primary') + " " +  title, name: anchor) end +

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
        content_tag(:button,  "Actions", class: "btn btn-#{style} dropdown-toggle btn-sm btn-flat", 'data-toggle': 'dropdown', type: 'button', 'aria-haspopup': 'true', 'aria-expanded': 'false', id: id) do
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

  def sidebar_li_active?(navbar)
    page_request_meta_info[:active_navbar_item].to_s == navbar.to_s
  end

  def navbar_nav_active_class(navbar)
    page_request_meta_info[:active_navbar_item].to_s == navbar.to_s ? 'active' : ''
  end

  def need_breadcrumb
    %w(apps versions).include?(controller_name.to_s)  ||
      (controller_name.to_sym == :services && action_name.to_sym == :show) ||
      (controller_name.to_sym == :service_templates && action_name.to_sym == :show)

    true
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

  def chart_opts_helper(labels, label, used, total, colors = ["yellow", "red"])
    {
      labels: labels,
      datasets: [
        {
          label: label,
          backgroundColor: colors,
          borderColor: ["white"],
          data: [used, total]
        }]
    }
  end

  def info_show_helper hash, classes = []
    classes.unshift 'dl-horizontal'
    content_tag(:dl, class: classes.join(" ")) do
      hash.each_pair do |k,v|
        concat content_tag(:dt, k)
        concat content_tag(:dd, v)
      end
    end
  end

  def box_helper color = "default", &block
    content_tag :div, class: "box box-#{color}", style: 'position: relative;' do
      capture &block if block_given?
    end
  end

  def box_header_helper title = "", icon = "cogs", &block
    content_tag :div, class: "box-header with-border" do
      concat content_tag(:h4, fa_icon(icon) + "       " + title, class: 'box-title')
      concat(capture &block) if block_given?
    end
  end

  def box_body_helper &block
    content_tag :div, class: "box-body" do
      capture &block if block_given?
    end
  end

  def sidebar_li_helper id, icon, text, link, is_tree = false, extra_labels = {}, icon_class = "default", &block
    classes = []
    classes.push("tree") if is_tree
    classes.push("menu-open") if is_tree
    classes.push("active") if is_tree
    classes.push("active") if sidebar_li_active?(id)

    content_tag(:li, class: classes.join(" ")) do
      content_tag(:a, href: link, data: { turbolinks: false }) do
        concat(fa_icon(icon, class: icon_class))
        concat(content_tag(:span, text))
        concat(content_tag(:span, class: "pull-right-container") {
          concat(fa_icon('angle-left', class: 'pull-right')) if is_tree
          extra_labels.each_pair do |color, value|
            concat(content_tag(:small, value, class: "label bg-#{color}"))
          end
        })
        concat(capture(&block)) if block_given?
      end
    end
  end

  def danger_btn_helper defaults = []
    "btn btn-danger btn-sm btn-flat" + " " + defaults.join(" ")
  end

  def primary_btn_helper defaults = []
    "btn btn-primary btn-sm btn-flat" + " " + defaults.join(" ")
  end

  def success_btn_helper
    "btn btn-success btn-sm btn-flat"
  end

  def graphna_panel name, panelId, interval = 5.minutes, refresh = 5, width = nil, height = nil
    width = width || main_content_width
    path =  graphna_path + "#{name}?refresh=#{refresh}s&orgId=1&panelId=#{panelId}&from=#{(Time.now - interval).to_i * 1000}&to=#{Time.now.to_i * 1000}&theme=light"

      "<iframe src='#{path}' width='#{width}' height='#{height}' frameborder='0'> </iframe>".html_safe
    end

  def docker_containers_graphna_panel panelId, service_name="All", app_name="All", interval = 5.minutes,  refresh = 5
    width = session[:width] || 1200
    height = 150
    path =  graphna_path + "docker-containers?refresh=#{refresh}s&orgId=1&panelId=#{panelId}&from=#{(Time.now - interval).to_i * 1000}&to=#{Time.now.to_i * 1000}&theme=light&var-service_name=#{service_name}&var-app_name=#{app_name}"

      "<iframe src='#{path}' width='#{width}' height='#{height}' frameborder='0'> </iframe>".html_safe
    end
 
  def main_content_width
    session[:width].to_i || 1200
  end
end
