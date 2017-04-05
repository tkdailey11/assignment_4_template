# == Schema Information
#
# Table name: alerts
#
#  id           :integer          not null, primary key
#  status       :integer
#  delivered_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer
#

require 'test_helper'

class AlertTest < ActiveSupport::TestCase
  test "new attributes exist" do
    assert Alert.column_names.include?('message')
    assert Alert.column_names.include?('criterion')
    assert Alert.column_names.include?('youtube_search_id')
  end

  test "enumerated attribute criterion works" do
    a = Alert.new
    assert a.criterion = 'change_in_top_x'
    assert Alert.change_in_top_x.respond_to?(:count)
    assert Alert.change_in_top_x.respond_to?(:first)
  end
end
