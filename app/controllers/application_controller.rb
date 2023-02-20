# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user, :current_admin?

  def current_user
    @user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_admin?
    current_user && current_user.admin?
  end
end
