class LoginController < ApplicationController
  def index
    @client_id = ENV['GH_BASIC_CLIENT_ID']
  end
  def callback
    session_code = params[:env]
    result = HTTParty.post('https://github.com/login/oauth/access_token', query: {
                             client_id: @client_id,
                             client_secret: ENV['GH_BASIC_CLIENT_SECRET'],
                             code: session_code })

    @current_user = User.find_or_create_by_token(result[:access_token])
  end
end
