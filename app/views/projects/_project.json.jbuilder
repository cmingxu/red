json.extract! project, :id, :namespace_id, :dockerfile, :user_id, :group_id, :version_format, :created_at, :updated_at
json.url project_url(project, format: :json)