require 'test_helper'

class YoutubeSearchesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    log_in_as(@user)
  end

  test "should get new" do
    get new_youtube_search_path
    assert_response :success
  end
end
