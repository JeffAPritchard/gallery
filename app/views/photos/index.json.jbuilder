json.array!(@photos) do |photo|
  json.extract! photo, :gui_name, :file_name, :tags
  json.url photo_url(photo, format: :json)
end
