class User::VerificationsController < ApplicationController
  before_action :authenticate!

  before_action -> { check_root_for :verification }

  before_action :retrieve_verification

  def create
    unless @verification.send_instructions
      return render_validation_errors(@verification)
    end
    head :no_content
  end

  def update
    unless @verification.complete
      return render_validation_errors(@verification)
    end
    head :no_content
  end

  protected

  def retrieve_verification
    @verification = Verification.new(params[:verification], model: current_user)
  end
end
