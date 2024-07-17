class FollowsController < ApplicationController

    def create
        target_user = User.find_by(id: params[:target_user_id])
        if target_user.present?
            Follow.create(
                follow_user_id: @current_user.id,
                followed_user_id: target_user.id, 
            )
            redirect_to("/users/#{target_user.id}")
        else
            redirect_to("/")
        end
    end

    def follows
        follow_user_ids = @current_user.follow_users.pluck(:followed_user_id)
        @follow_users = User.where(id: follow_user_ids)
        # Rspecで@current_user.follows でフォローしている一覧が取れているか確認したい
        # @follows = [] がゴール
        # アソシエーションを使う
    end

    def followers
        follower_user_ids = @current_user.follower_users.pluck(:follow_user_id)
        @follower_users = User.where(id: follower_user_ids)
    end

    def destroy
        # binding.pry

        ### Rspecで動作確認をし,フォロー解除自体は出来る事は確認
        target_user = User.find_by(id: params[:target_user_id])
        if target_user.present?
            follow = Follow.find_by(follow_user_id: @current_user.id, followed_user_id: params[:target_user_id])
            follow.destroy
            redirect_to("/users/#{target_user.id}")
        else
            redirect_to("/")
        end

        
        ###別案
        # target_user = User.find_by(id: params[:target_user_id])
        # @target_user = Follow.find_by(
        #     follow_user_id: @current_user.id,
        #     followed_user_id: target_user.id 
        # )
        # @target_user.destroy
    end
end
