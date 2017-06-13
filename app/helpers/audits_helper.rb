module AuditsHelper
  def audit_action(locale = :en)
    case locale.to_s
    when 'en'
      {
        "create": "Create",
        "update": "Update",
        "change": "Change",
        "delete": "Delete",
        "destroy": "Destroy",
        "run": "Run",
        "stop": "Stop",
        "restart": "Restart",
        "scale": "Scale",
        "grant": "Grant",
        "login": "Login",
        "logout": "Logout",
      }
    when 'zh-CN'
      {
        "create": "创建",
        "update": "更新",
        "change": "修改",
        "delete": "删除",
        "destroy": "删除",
        "run": "发布",
        "stop": "停止",
        "restart": "重启",
        "scale": "扩缩",
        "grant": "授权",
        "login": "登录",
        "logout": "登出",
      }
    end
  end
end
