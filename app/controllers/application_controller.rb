class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :authenticate_user!, if: :admin_request?

  rescue_from Pundit::NotAuthorizedError do
    redirect_to admin_root_path, alert: "You are not authorized to perform this action."
  end

  private

  def admin_request?
    request.path.start_with?("/admin")
  end
end
