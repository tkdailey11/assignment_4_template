# == Schema Information
#
# Table name: videos
#
#  id                :integer          not null, primary key
#  title             :string
#  url               :string
#  view_count        :integer
#  comment_count     :integer
#  youtube_search_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  like_count        :integer
#  dislike_count     :integer
#  favorite_count    :integer
#  channel_name      :string
#  youtube_id        :string
#  published_at      :date
#  thumbnail_url     :string
#

# represents a video that exists on Youtube
class Video < ApplicationRecord
  # TODO:  refactor to associate this model with one executed search object,
  # instead of a youtube_search_object.  This involves both changing the
  # table schema and adding the correct association declaration here.

  validates :title, presence: true
  validates :view_count, presence: true
  validates :comment_count, presence: true
end
