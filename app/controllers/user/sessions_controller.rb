class User::SessionsController < Devise::SessionsController
  before_action -> { check_root_for resource_name }

  def create
    super do |user|
      response = { email: user.email, token: user.authentication_token }

      render json: response, status: :created and return
    end
  end

  protected

  def check_root_for(resource_name)
    render_bad_request unless params[resource_name]
  end
end
