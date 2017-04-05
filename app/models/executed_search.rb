# == Schema Information
#
# Table name: executed_searches
#
#  id                :integer          not null, primary key
#  youtube_search_id :integer
#  triggered_by      :integer
#  started_at        :datetime
#  finished_at       :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class ExecutedSearch < ApplicationRecord
  belongs_to :youtube_search
  has_one :user, through: :youtube_search
  has_many :videos

  before_save :set_defaults

  enum triggered_by: [:ad_hoc_query, :scheduled_query]

  scope :most_recent, lambda{ |n = 1|
    if n == 1
      order('executed_searches.started_at desc').limit(n).first
    else
      order('executed_searches.started_at desc').limit(n)
    end
  }

  delegate :name, to: :youtube_search

  # This is a way of creating a virtual attribute that
  # handles setting the enumerated value correctly for
  # triggered_by.  I'm creating it because it makes things
  # easier when creating or updating an ExecutedSearch object
  # (because many of those Rails functions take a hash of
  # attributes and their values).
  def is_ad_hoc=(true_or_false)
    if true_or_false
      self.triggered_by = 'ad_hoc_query'
    else
      self.triggered_by = 'scheduled_query'
    end
  end


  def run
    # save the start time...
    self.started_at = Time.now.in_time_zone
    # remove any currently associated videos
    videos.delete_all

    Yt::Collections::Videos.new.where(q: youtube_search.search_terms, order: 'viewCount', safe_search: 'strict').first(YoutubeSearch::MAX_RESULTS).each do |v|
      # has_many.create will instantiate a new object associated with this one via
      # the foreign key and save it -- see the Rails API documents for has_many
      new_video = videos.create(
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

    # save the finish time...
    self.finished_at = Time.now.in_time_zone
    # write this object to the DB
    save!
  end

  # Compare the videos associated with this search to those of another
  # search.  Return an array of any that are only in this search.
  def compare_to(other_executed_search)
    # TODO:  Implement this.
    #
    # This kind of operation is typically very easy with ActiveRecord
    # because the has_many relationship returns an array-like list of
    # objects and we can just do a set operation between the two
    # collections of videos.  The comparison used, however, is based on
    # the objects themselves, and we need to be a bit more particular
    # about the comparisons...specifically, we need to use the youtube_id
    # as our identifier.
    #
    # There are lots of ways to do this.  It's an easy query for a relational
    # database to do, but we'd have to write some SQL in here.  We could
    # craft the SQL using ActiveRecord functions, but perhaps the easiest
    # way is to just use Ruby.  You could collect a set of youtube_id's from
    # one set, and another colleciton of youtube_id's from the other set and
    # just compare those...although remember you need to return an array
    # of Video objects, not just youtube_ids.
    #
    # Some hints:
    # - if you like SQL, you can execute SQL directly against the connection
    #   object every ActiveRecord class has, e.g.:
    #    ExecutedSearch.connection.execute(sql goes here)
    # - the pluck() function is helpful -- if you call it on a model (or a
    #   collection of objects) and you pass it the name of a field, it will
    #   return an array of the field values.
    # - Remember that the self.videos and other_executed_search.videos are
    #   collections of Video objects.  Additionally, they respond to just
    #   about any method you can call on an array.
  end

  private

  def set_defaults
    self.triggered_by ||= 'ad_hoc_query'
  end
end
