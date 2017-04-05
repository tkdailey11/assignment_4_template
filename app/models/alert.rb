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

class Alert < ApplicationRecord
  belongs_to :user

  scope :most_recently_created, ->(n) { order('alerts.created_at desc').limit(n) }
  scope :most_recently_delivered, ->(n) { order('alerts.delivered_at desc').limit(n) }

  enum status: [:generated, :delivered]
end
