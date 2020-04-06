class Api::V1::PostsController < Api::V1::ApiController
  include Api::V1::Concerns::Authenticator
  before_action :authorize_as_user, only: %i[index show create]
  before_action :set_post, only: %i[show]

  def index
    @posts = Post.subscribed(current_user.following)
    render json: @posts.order(created_at: :desc), status: :ok, serializer: PostSerializer
  end

  def show
    render json: @post, status: :ok
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      render json: @post, status: :ok
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end
  private

  def post_params
    params.require(:post).permit(:message)
  end

  def set_post
    @post = Post.find(params[:id])
  end


end
