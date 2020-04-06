module Api
  module V1
    module Concerns
      module Authenticator
        def validate_user
          if auth_params[:email].blank? || auth_params[:password].blank?
            render json: { message: I18n.t('invalid_credentials') }, status: :forbidden
          else
            authenticate
          end
        end

        def authenticate
          unless entity.present? && entity.authenticate(auth_params[:password])
            render json: { message: I18n.t('not_found') }, status: :unauthorized
          end
        end

        def auth_token
          if entity.respond_to? :to_token_payload
            Knock::AuthToken.new payload: entity.to_token_payload
          else
            Knock::AuthToken.new payload: { sub: entity.id }
          end
        end

        def entity
          @entity ||= if User.respond_to? :from_token_request
            User.from_token_request(request)
          else
            User.find_by(email: auth_params[:email])
          end
        end
      end
    end
  end
end