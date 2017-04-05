class YoutubeSearchesController < ApplicationController
  def new
    @ys = YoutubeSearch.new
  end

  def create
    @ys = YoutubeSearch.new(safe_params.merge(user: current_user))
    if @ys.save
      redirect_to @ys
    else
      render :edit
    end
  end

  def edit
    @ys = YoutubeSearch.find(params[:id])
  end

  def update
    @ys = YoutubeSearch.find(params[:id])
    @ys.update_attributes(safe_params)
    render :edit
  end

  def show
    @ys = YoutubeSearch.find(params[:id])
    render :edit
  end

  private

  # whitelist parameters coming from form posts to ensure
  # security
  def safe_params
    params.require(:youtube_search).permit(:search_terms)
  end
end
