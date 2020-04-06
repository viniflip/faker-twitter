module ApiHelper
  def authenticated_header(user)
    Knock::AuthToken.new(payload: { sub: user.id }).token
  end
end