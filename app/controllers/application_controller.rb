class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  #   protect_from_forgery with: :null_session

  def not_found
    render json: { errors: 'Not found action' }, status: :not_found
  end

  respond_to :json

  #   before_action :underscore_params!
  #   before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user

  private

  #   def configure_permitted_parameters
  #     devise_parameter_sanitizer.for(:sign_up) << :username
  #   end

  def authenticate_user!(options = {})
    head :unauthorized unless signed_in?
  end

  def current_user
    # pp "!!!!!!!!!!!!!!!!!!!!11"
    @current_user ||= super || User.find(@current_user_id)
  end

  def signed_in?
    @current_user_id.present?
  end

  def authenticate_user
    if request.headers["Authorization"].present?
      authenticate_or_request_with_http_token do |token|
        begin
          jwt_payload = JWT.decode(token, ENV['JWT_SECRET_KEY']).first

          @current_user_id = jwt_payload["id"]
        rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
          head :unauthorized
        end
      end
    end
  end
end
