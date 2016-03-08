class User::ProfilesController < ApplicationController
  before_action :authenticate!

  def show
    render json: profile
  end

  def update
    unless profile.update(profile_params)
      return render_validation_errors(profile)
    end
    render json: profile
  end

  protected

  def profile
    @profile ||= current_user.profile
  end

  def profile_params
    attributes(:profiles).permit(:nickname, :short_description, :description)
  end
end
