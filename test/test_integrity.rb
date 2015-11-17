require "pry-byebug"
require_relative 'helper' # require the helper


class UserAcceptanceTest < Minitest::Test
  include Capybara::DSL # gives you access to visit, etc.

  def clear_all_in_database
    Tweet.destroy_all
    User.destroy_all
    Follow.destroy_all
  end

  def test_the_main_page
    visit '/logout'
    visit '/'
    assert page.has_content?("Welcome to Nanotwitter!")
  end

  def test_create_user_sample
    # create first user sample
    user = User.find_by name: "sample"
    if !user
      visit '/register'
      fill_in('name', :with => 'sample')
      fill_in('display_name', :with => 'SampleUser')
      fill_in('email', :with => 'sample@sample.com')
      fill_in('password', :with => 'password')
      click_button('register-submit')
    end
  end

  def test_create_user_sample1
    # create another user
    user = User.find_by name: "sample1"
    if !user
      visit '/register'
      fill_in('name', :with => 'sample1')
      fill_in('display_name', :with => 'AnotherUser')
      fill_in('email', :with => 'anothersample@sample.com')
      fill_in('password', :with => 'password')
      click_button('register-submit')
    end
  end

  def test_create_user_sample2
    # create second user
    user = User.find_by name: "sample2"
    if !user
      visit '/register'
      fill_in('name', :with => 'sample2')
      fill_in('display_name', :with => 'SecondUser')
      fill_in('email', :with => 'secondsample@sample.com')
      fill_in('password', :with => 'password')
      click_button('register-submit')
    end
  end

  def test_login_with_invalid_user
    visit '/login'
    page.has_content?('Your LogIn info')
    fill_in('name', :with => 'sample3')
    fill_in('password', :with => 'password')
    click_on('login-submit')
    assert page.has_content?('User not found or password is not correct')
  end

  def test_login_with_valid_user
    visit '/login'
    fill_in('name', :with => 'sample')
    fill_in('password', :with => 'password')
    click_on('login-submit')

    assert page.has_content?('SampleUser')
  end

  def test_post_new_tweet
    visit '/login'
    fill_in('name', :with => 'sample')
    fill_in('password', :with => 'password')
    click_on('login-submit')
    fill_in('tweet-text', :with => 'This is just a sample, running with minitest')
    click_on('tweet-submit')
    assert page.has_content?('This is just a sample, running with minitest')
  end

  def test_tweets
    visit '/login'
    fill_in('name', :with => 'sample')
    fill_in('password', :with => 'password')
    click_on('login-submit')
    click_on('Tweets')
    assert page.has_content?('This is just a sample, running with minitest')
  end

end
