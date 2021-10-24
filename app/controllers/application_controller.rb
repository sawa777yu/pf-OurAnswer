class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: %i[top show search search_genre new_guest]
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name our_answers_id])
  end
end
