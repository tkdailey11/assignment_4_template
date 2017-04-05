require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    log_in_as(@user)
  end

  def test_profile
    get edit_user_path(@user)
    assert_response 200
    assert_includes @response.body, @user.first_name
    assert_includes @response.body, @user.last_name
    assert_includes @response.body, @user.email
  end
end
