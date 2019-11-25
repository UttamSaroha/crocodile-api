class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_friend_to_add, only: :create
  before_action :check_friend_request, only: :create
  before_action :check_friendship , only: :destroy
  before_action :load_friendship , only: :destroy
  before_action :only_user_involved, only: :destroy

def create

Friendship.add_friend(current_user.id,@friend_to_add.id )
 redirect_to @friend_to_add
end

  def destroy

Friendship.unfriend(current_user.id, @friend.id )
 redirect_to @friend
  end

  private

def load_friend_to_add
 @friend_to_add = User.find(params[:id])

end

def check_friend_request
  unless FriendRequest.exists?(user_id:params[:id] , friend_id: current_user.id)
    flash[:danger] = "Friend Request needed."
    redirect_to @friend_to_add
  end
end

  def check_friendship
    unless Friendship.exists?(params[:id])
      flash[:danger] = "user is not your friend"
      redirect_to current_user
    end
  end



  def load_friendship
    @friendship = Friendship.find(params[:id])
    @friend = @friendship.friend
    @user = @friendship.user
  end


  def only_user_involved
    unless @user == current_user
      flash[:danger] = "You are not authorized to do that."
      redirect_to @friend
    end
  end
end
