# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :photo do
    gui_name "BogusGUIName"
    file_name "BogusFileName"
    description "BogusDescriptionString"
    tags ""
  end
end
