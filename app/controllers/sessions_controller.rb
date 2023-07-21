class SessionsController < ApplicationController
    def create
        @user = User.find_by(username: params[:username])
      
        if @user && @user.authenticate(params[:password])
          session = @user.sessions.create
          cookies.permanent[:twitter_session_token] = session.token
          render json: @user, status: :created
        else
          render json: { error: "Invalid username or password" }, status: :unauthorized
        end
      end
      
      def authenticated
        token = cookies[:twitter_session_token]
        session = Session.find_by(token: token)
      
        if session
          render json: { authenticated: true }, status: :ok
        else
          render json: { authenticated: false }, status: :unauthorized
        end
      end
      
      def destroy
        token = cookies[:twitter_session_token]
        session = Session.find_by(token: token)
        session&.destroy
        cookies.delete(:twitter_session_token)
        head :no_content
      end
      
end
