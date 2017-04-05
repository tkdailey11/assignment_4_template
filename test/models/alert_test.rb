# == Schema Information
#
# Table name: alerts
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  status       :integer
#  delivered_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class AlertTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
