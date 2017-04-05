# == Schema Information
#
# Table name: youtube_searchers
#
#  id           :integer          not null, primary key
#  name         :string
#  search_terms :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class YoutubeSearcherTest < ActiveSupport::TestCase
  test 'youtube api query returns results' do
    video_count = Video.count
    @yts = youtube_searches(:farmall_tractors)
    @yts.save
    assert Video.count > video_count
  end

end
