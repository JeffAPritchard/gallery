json.array!(@categories) do |category|
  json.extract! category, :name, :css_class, :icon
  json.url category_url(category, format: :json)
end
