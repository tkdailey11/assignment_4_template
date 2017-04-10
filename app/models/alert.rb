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

class Alert < ApplicationRecord
  # TODO:  setup the association with a youtube_search and
  # redefine the association with a user.
  # Remember that the user association is no longer a direct one...you have
  # to go through the youtube_search association first.

  scope :most_recently_created, ->(n) { order('alerts.created_at desc').limit(n) }
  scope :most_recently_delivered, ->(n) { order('alerts.delivered_at desc').limit(n) }

  enum status: [:generated, :delivered]
  enum criterion: [:change_in_top_x] # this could grow as we add more alert types

  before_save :set_defaults

  # scan through the list of alerts for any that haven't been delivered and do so
  # Note that this is a class method, not an object method (because it's defined
  # using the 'self.' syntax).  You call it on the class, e.g. "Alert.deliver!"
  def self.deliver!
    Alert.generated.each do |alert|
      alert.deliver!
    end
  end

  # deliver a particular alert based on the user's preferences
  # Note that this is an object method, not a class method, so the fact that it
  # shares the same name as the previous method is ok...they're defined on different
  # things.  This one is called on an Alert object, e.g. "Alert.new.deliver!"
  def deliver!
    Rails.logger.info("Delivering an alert to #{user.full_name}: #{self.message}")
    # change the status flag on the alert
    self.status = 'delivered'
    self.save
  end

  private

  def set_defaults
    self.status ||= 'generated'
    self.criterion ||= 'change_in_top_x'
  end
end
