require "pry-byebug"
require_relative 'helper' # require the helper


class UserAcceptanceTest < Minitest::Test
  include Capybara::DSL # gives you access to visit, etc.


  def test_the_main_page
    visit '/'
    assert page.has_content?("Nanotwitter")
    assert page.has_content?("Message")
    assert page.has_content?("Tweet")
  end

  def test_create_user_sample
    # create first user sample
    visit '/register'
    fill_in('name', :with => 'sample')
    fill_in('display_name', :with => 'SampleUser')
    fill_in('email', :with => 'sample@sample.com')
    fill_in('password', :with => 'password')
    click_button('register_submit')
  end

  def test_create_user_sample1
    # create second user
    visit '/register'
    fill_in('name', :with => 'sample1')
    fill_in('display_name', :with => 'AnotherUser')
    fill_in('email', :with => 'anothersample@sample.com')
    fill_in('password', :with => 'password')
    click_button('register_submit')
  end


  def test_login_non_exist_user
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

  def test_followship
    visit '/login'
    fill_in('name', :with => 'sample')
    fill_in('password', :with => 'password')
    click_on('login_submit')
    visit '/user/sample1'
    if find_by_id('followship_btn') && page.has_content?('Follow')
      click_on('followship_btn')
      user_sample1 = User.find_by name: "sample1"
      binding.pry
      user_sample1.followers.each {|single| if single.name == "sample" then assert true end}
    else
      click_on('followship_btn')
      user_sample1.followers.each {|single| if single.name == "sample" then assert false end}
    end
  end

end
