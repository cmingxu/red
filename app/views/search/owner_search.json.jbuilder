json.array! [@groups + @users].flatten do |owner|
  json.type owner.class.to_s
  json.name owner.display
  json.id owner.id
end
