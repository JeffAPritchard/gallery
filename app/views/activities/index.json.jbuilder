json.array!(@activities) do |activity|
  json.extract! activity, :name, :description, :icon, :url, :category_id
  json.url activity_url(activity, format: :json)
end
