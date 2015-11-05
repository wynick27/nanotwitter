source "https://rubygems.org"

gem "sinatra"
gem "activerecord"
gem "sinatra-activerecord"
gem "pry-byebug"
gem "faker"
group :production do
  gem "pg"
end

group :test do
gem 'capybara'
gem 'minitest-capybara'
gem 'capybara-webkit'
gem 'selenium-webdriver'
gem 'capybara_minitest_spec'
end

group :test,:development do
  gem "sqlite3"
end
