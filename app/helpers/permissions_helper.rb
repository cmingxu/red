module PermissionsHelper
  def permission_access(locale = :en)
    case locale.to_s
    when 'en'
      {
        "Admin": "admin",
        "Read": "read",
        "Write": "write",
      }
    when 'zh-CN'
      {
        "管理": "admin",
        "可读": "read",
        "可写": "write",
      }
    end
  end
end
