class My::DetailsController < My::BaseController


  def show
    @student_details = @student.student_details

    @username = request.headers[PapyrusSettings.auth_cas_header]
    @alt_username = request.headers[PapyrusSettings.auth_cas_header_alt]
    @courses = request.headers[PapyrusSettings.course_listing_header]
  end

end
