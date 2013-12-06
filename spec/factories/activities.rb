# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :activity do
    name "MyString"
    description "MyText"
    icon "MyString"
    url "MyString"
    category_id 1
  end
end
