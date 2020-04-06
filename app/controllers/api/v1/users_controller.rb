class Api::V1::UsersController < Api::V1::ApiController
  include Api::V1::Concerns::Authenticator

  before_action :validate_user, only: %i[login change_password]
  before_action :authorize_as_user, only: %i[index show follow unfollow current]
  before_action :set_user, only: %i[show update follow unfollow]

  def login
    response.headers['Access-Token'] = auth_token.token
    render json: entity, status: :ok
  end

  def follow
    current_user.follow(@user.id)
    render json: current_user, status: :ok
  end

  def unfollow
    current_user.unfollow(@user.id)
    render json: current_user, status: :ok
  end

  def change_password
    @entity.password = auth_params[:new_password]
    if @entity.save
      render json: { message: I18n.t('change_password_successfully') }, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    render json: User.all.order(created_at: :desc), status: :ok
  end

  def current
    render json: current_user, status: :ok
  end

  def show
    render json: @user, status: :ok
  end

  def create
    @user = User.new(user_params)
    if @user.save
      response.headers['Access-Token'] = Knock::AuthToken.new(payload: { sub: @user.id }).token
      render json: @user, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def auth_params
    params.require(:auth).permit(:email, :password, :new_password)
  end
end
