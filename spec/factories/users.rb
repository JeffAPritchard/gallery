# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name "jeffp"
    email "foo@example.com"
    password "foobarfoo"
  end
end
