json.extract! build, :id, :project_id, :serial_num, :version_name, :build_status, :created_at, :updated_at
json.url build_url(build, format: :json)