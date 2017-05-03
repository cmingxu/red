json.extract! service_template, :id, :name, :icon, :group_id, :user_id, :raw_config, :desc, :readme, :created_at, :updated_at
json.url service_template_url(service_template, format: :json)