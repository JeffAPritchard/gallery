module ApplicationHelper
  
  def not_in_test_mode
    !(ENV["RAILS_ENV"] == 'test')
  end
  
end
