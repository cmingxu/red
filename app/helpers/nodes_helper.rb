module NodesHelper

  def container_state_helper state
    case state.to_sym
    when :running
      content_tag :div, class: 'label label-success' do
        state
      end
    when :exited
      content_tag :div, class: 'label label-danger' do
        state
      end
    else
      content_tag :div, class: 'label label-primary' do
        state
      end
    end
  end
end
