class My::BaseController < ApplicationController

  before_filter :authorize_controller, :load_student, :sync_courses

  before_filter :check_terms_acceptance, except: :welcome


  def welcome
    ## if student is first timer, show details welcome page
    ## otherwise show terms
    if @student.last_logged_in_at == nil
      redirect_to my_details_path(review: true)
    else
      redirect_to my_terms_path
    end
  end


  private

  def sync_courses
    if PapyrusSettings.course_sync_on_login == PapyrusSettings::TRUE && session[:courses_synced] == nil
      session[:courses_synced] = true # mark it as synced here, to avoid introducing an extra dependecy into course_sync_controller
      redirect_to sync_courses_path
    end
  end


  def authorize_controller
     authorize! :show, :student
  end

  def load_student
    @student = Student.find(current_user.id)
  end

  def check_terms_acceptance
    redirect_to my_terms_path unless session[:terms_accepted]
  end

end
