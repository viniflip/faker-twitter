class Api::V1::ApiController < ActionController::API
  include Knock::Authenticable

  def authorize_as_user
    return_unauthorized if current_user.nil?
  end

  def return_unauthorized
    render json: { message: I18n.t('unauthorized_user') }, status: :unauthorized
  end
end
