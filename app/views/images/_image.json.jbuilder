json.extract! image, :id, :name, :hash, :size, :created_at, :updated_at
json.url image_url(image, format: :json)