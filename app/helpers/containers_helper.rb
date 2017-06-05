module ContainersHelper
  def parse_container(container)
    os = OpenStruct.new
    os.id = container.id
    os.state = container.info["State"]
    os.status = container.info["Status"]
    os.name = container.info["Names"].try(:first)
    os.command = container.info["Command"]
    os.image = container.info["Image"]
    os.ip = container.info["NetworkSettings"]["Networks"].try(:values).try(:first).try(:fetch,"IPAddress")
    os.ports = "" # (container.info["Ports"].try(:first) || {}).try(:fetch, "PublicPort")
    os
  end

  def container_actions
    [
      {action: "start", display: "启动", icon: "play", btn_suffix: "success"},
      {action: "stop", display: "停止", icon: "stop", btn_suffix: "danger"},
      {action: "kill", display: "杀死", icon: "", btn_suffix: "danger"},
      {action: "restart", display: "重启", icon: "play", btn_suffix: "primary"},
      {action: "pause", display: "暂停", icon: "pause", btn_suffix: "primary"},
      {action: "resume", display: "恢复", icon: "start", btn_suffix: "primary"},
      {action: "remove", display: "移除", icon: "trash", btn_suffix: "danger"},
    ]
  end
end
