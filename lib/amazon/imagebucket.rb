module ImageBucket
  IMAGE_BUCKET = (ENV["RAILS_ENV"] == 'test') ? 'jeffp-test-images' : 'jeffp-images'
  TEST_IMAGE_BUCKET = 'jeffp-test-images'
end