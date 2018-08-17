class PicturesController < ApplicationController
  before_action :ensure_logged_in, except: [:show, :index]
  before_action :load_picture, only: [:show, :edit, :update, :destory]
  before_action :ensure_user_owns_picture, only: [:edit]

  def index
    @pictures = Picture.all
    @most_recent_pictures = Picture.most_recent_five
    @older_one_month = Picture.created_before(Time.now)
    @pics_in_2017 = Picture.pictures_created_in_year("2017")
    @pics_in_2016 = Picture.pictures_created_in_year("2016")
  end

  def show
    # @picture = Picture.find(params[:id])
  end

  def new
    @picture = Picture.new
  end

  def create
    # render text: "Received POST request to '/pictures' with the data URL: #{params}"

    @picture = Picture.new

    @picture.title = params[:picture][:title]
    @picture.artist = params[:picture][:artist]
    @picture.url = params[:picture][:url]
    @picture.user_id = current_user.id

    if @picture.save
      # if the pciture gets saved, generate a get reqest to "/picture" (the index) redirect_to "/pictures"
      redirect_to "/pictures"
    else
      # otherwise render new.html.erb
      render :new
    end
  end

  def edit
    # @picture = Picture.find(params[:id])
  end

  def update
    # @picture = Picture.find(params[:id])

    @picture.title = params[:picture][:title]
    @picture.artist = params[:picture][:artist]
    @picture.url = params[:picture][:url]
    @picture.created_at = params[:picture][:created_at]

    if @picture.save
      redirect_to "/pictures/#{@picture.id}"
    else
      render :edit
    end
  end

  def destroy
    # @picture = Picture.find(params[:id])
    @picture.destroy
    redirect_to "/pictures"
  end

  private

  def ensure_user_owns_picture
    unless current_user == @picture.user
      flash[:alert] = "Access Denied. Please Log In"
      redirect_to new_sessions_url
    end
  end

  def load_picture
    @picture = Picture.find(params[:id])
  end
end
