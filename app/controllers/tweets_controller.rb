class TweetsController < ApplicationController
    def create
        @tweet = current_user.tweets.new(tweet_params)
      
        if @tweet.save
          render json: @tweet, status: :created
        else
          render json: @tweet.errors, status: :unprocessable_entity
        end
      end
      
      def destroy
        @tweet = current_user.tweets.find(params[:id])
        @tweet.destroy
        head :no_content
      end
      
      def index
        @tweets = Tweet.all
        render json: @tweets
      end
      
      def index_by_user
        @user = User.find_by(username: params[:username])
        @tweets = @user.tweets
        render json: @tweets
      end
      
      private
      def tweet_params
        params.require(:tweet).permit(:message)
      end
      
      def current_user
        token = cookies[:twitter_session_token]
        session = Session.find_by(token: token)
        User.find(session.user_id)
      end
      
end
