class SessionsController < ApplicationController

  include AuthenticatedSystem

  def new
    redirect_back_or_default(admin_admin_path) and return if logged_in?
  end

  def create
    logout_keeping_session!

    user = User.authenticate(params[:email], params[:password])
    if user && user.not_blocked?
      user.update_last_login
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      redirect_back_or_default(admin_admin_path)
    elsif user && user.blocked?
      note_failed_signin
      @email       = params[:email]
      @remember_me = params[:remember_me]
      flash[:alert] = <<-HTML
        <p class="error margin">Your user account is blocked temporally.<br />
        <a href="mailto:jmontgom@interaction.org">Write us</a> if this is a problem for you.</p>
      HTML
      render :action => 'new'
    else
      note_failed_signin
      @email       = params[:email]
      @remember_me = params[:remember_me]
      flash[:alert] = '<p class="error">Your email / password is not correct</p>'
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    redirect_back_or_default('/', :notice => "You have been logged out.")
  end

  protected

    def note_failed_signin
      flash.now[:error] = "Couldn't log you in as '#{params[:email]}'"
      logger.warn "Failed email for '#{params[:email]}' from #{request.remote_ip} at #{Time.now.utc}"
    end

end
