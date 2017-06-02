class MesosController < SystemController
  before_action :set_breadcrumb
  def index
    @state = mesos_state
  end

  def mesos_state
    Rails.cache.fetch("mesos-object", expires_in: 60.second) do
      Mesos.new(leader: "http://114.55.130.152:5050").state
    end
  end

  def set_breadcrumb
  end
end
