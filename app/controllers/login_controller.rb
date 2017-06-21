class LoginController < ApplicationController
  skip_authorization_check


  def new

    if Rails.env.development? || Rails.env.vagrant?
        if params[:as].nil?
          username = User::ADMIN
        else
          username = params[:as]
        end
        alt_username = username
    else
       username = request.headers[PapyrusSettings.auth_cas_header]
       alt_username = request.headers[PapyrusSettings.auth_cas_header_alt]
    end

    
    users = User.unblocked.where("username = ? OR username = ?", username, alt_username)

    if users.size == 1

      user = users.first

      session[:user_id] = user.id
      session[:username] = user.name

      user.active_now!(User::ACTIVITY_LOGIN)

      if user.role == User::STUDENT_USER
        redirect_to my_student_portal_path
      else
        redirect_to root_url, notice: "Logged in!"
      end
    else
      flash.now.alert = "Invalid email or password"

      render layout: "simple"
    end
  end

  def destroy
    session[:user_id] = nil
    session[:terms_accepted] = nil
    cookies.delete("mayaauth", domain: PapyrusSettings.auth_cookies_domain)
    cookies.delete("pybpp", domain: PapyrusSettings.auth_cookies_domain)

    redirect_to PapyrusSettings.auth_cas_logout_redirect || "http://www.google.ca"
  end



end