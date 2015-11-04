require "pry-byebug"
require_relative 'helper' # require the helper


class UserAcceptanceTest < Minitest::Test
  include Capybara::DSL # gives you access to visit, etc.

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
      click_button('register_submit')
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
      click_button('register_submit')
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
      click_button('register_submit')
    end
  end

  def test_login_with_invalid_user
    visit '/login'
    page.has_content?('Your LogIn info')
    fill_in('name', :with => 'sample3')
    fill_in('password', :with => 'password')
    click_on('login_submit')
    assert page.has_content?('User not found or password is not correct')
  end

  def test_login_with_valid_user
    visit '/login'
    fill_in('name', :with => 'sample')
    fill_in('password', :with => 'password')
    click_on('login_submit')
    assert page.has_content?('SampleUser')
    assert page.has_content?('Home')
  end

  def test_post_new_tweet
    visit '/login'
    fill_in('name', :with => 'sample')
    fill_in('password', :with => 'password')
    click_on('login_submit')
    fill_in('tweet_text', :with => 'This is just a sample, running with minitest')
    click_on('tweet_submit')
    assert page.has_content?('This is just a sample, running with minitest')
  end

  # this is failed and need improvements
  def test_followship
    Capybara.current_driver = :webkit
    visit '/login'
    fill_in('name', :with => 'sample')
    fill_in('password', :with => 'password')
    click_on('login_submit')
    visit '/user/sample1'
    user_sample1 = User.find_by name: "sample1"
    #binding.pry
    #save_and_open_page

    if page.has_css?('.follow-btn')
      find('.follow-btn').click
      assert (user_sample1.followers.any? {|single| single.name == "sample" })
    elsif page.has_css?('.unfollow-btn')
      find('.unfollow-btn').click
    else
      assert false
    end
  end

  def test_tweets
    visit '/login'
    fill_in('name', :with => 'sample')
    fill_in('password', :with => 'password')
    click_on('login_submit')
    click_on('Tweets')
    assert page.has_content?('This is just a sample, running with minitest')
  end

  def test_followers
    Capybara.current_driver = :webkit
    visit '/login'
    fill_in('name', :with => 'sample2')
    fill_in('password', :with => 'password')
    click_on('login_submit')
    visit '/user/sample1'
    if page.has_css?('.follow-btn')
      find('.follow-btn').click
    end
    visit '/logout'

    visit '/login'
    fill_in('name', :with => 'sample1')
    fill_in('password', :with => 'password')
    click_on('login_submit')
    click_on('Followers')
    assert page.has_content?('SecondUser')
  end

  def test_followings
    Capybara.current_driver = :webkit
    visit '/login'
    fill_in('name', :with => 'sample2')
    fill_in('password', :with => 'password')
    click_on('login_submit')
    visit '/user/sample1'
    if page.has_css?('.follow-btn')
      find('.follow-btn').click
    end
    visit '/'
    click_on('Following')
    assert page.has_content?('AnotherUser')
  end

=begin
  def test_favourite
    Capybara.current_driver = :webkit
    visit '/login'
    fill_in('name', :with => 'sample')
    fill_in('password', :with => 'password')
    click_on('login_submit')
    fill_in('tweet_text', :with => 'Sampel for favorites')
    click_on('tweet_submit')
    visit '/'
    #binding.pry
    find('.fav-btn').click
    click_on('Favourites')
    assert page.has_content?('Sampel for favorites')
  end
=end

end
