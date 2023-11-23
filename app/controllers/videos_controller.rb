class VideosController < ApplicationController
  before_action :authenticate_user!
  before_action :get_course
  before_action :get_tut

  def show
    unless @tut.user_has_access?(current_user) || current_user.try(:type)
      redirect_to course_payments_path(params[:course_id]), alert: "You Have Not Payed for the course yet!"
    else
      @single_video = ActiveStorage::Blob.find_by(filename: params[:video_title])
      if params[:video_title].present?
        if current_user.watched_video.present?
          current_user.watched_video.update(user_id: current_user.id, tut_id: params[:id], video_filename: params[:video_title])
        else
          WatchedVideo.create(user_id: current_user.id, tut_id: params[:id], video_filename: params[:video_title])
        end
      end
      @tuts = @course.tuts.all
    end
  end

  private 

  def get_course
    @course = Course.find(params[:course_id])
  end

  def get_tut
    @tut = Tut.find(params[:id])
  end

end