# == Schema Information
#
# Table name: youtube_searches
#
#  id           :integer          not null, primary key
#  name         :string
#  search_terms :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer
#

# A class to manage the searching of Youtube and creation
# of objects to store the results.
class YoutubeSearch < ApplicationRecord
  belongs_to :user
  has_many :videos

  scope :most_recent, ->(n) { order('youtube_searches.created_at desc').limit(n) }

  validates :search_terms, presence: true

  MAX_RESULTS = 30

  # do the search and the saving of associated video objects *after* saving
  # this object because the parent object of a has_many relationship must
  # be saved before any of the associated objects (which makes sense because
  # you need the foreign_key to make the link, and if the parent object
  # doesn't have an ID yet, there's no way to set that foreign key field).
  after_save :search

  private

  def search
    # remove any currently associated videos
    self.videos.delete_all

    results = Yt::Collections::Videos.new.where(q: youtube_search.search_terms, order: 'viewCount', safe_search: 'strict').first(YoutubeSearch::MAX_RESULTS)
    results.each do |v|
      # has_many.create will instantiate a new object associated with this one via
      # the foreign key and save it -- see the Rails API documents for has_many
      new_video = self.videos.create(
        title: v.title,
        comment_count: v.comment_count || 0,
        view_count: v.view_count || 0,
        like_count: v.like_count || 0,
        dislike_count: v.dislike_count || 0,
        channel_name: v.channel_title,
        published_at: v.published_at,
        youtube_id: v.id,
        url: v.embed_html,
        thumbnail_url: v.thumbnail_url)
      if new_video
        Rails.logger.info("Successfully created a video from search: #{new_video.inspect}")
      else
        Rails.logger.error("Unable to save a video result: #{new_video.errors.full_messages}")
      end
    end
  end
end
