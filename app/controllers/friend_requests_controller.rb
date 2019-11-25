class FriendRequestsController < ApplicationController

  before_action :authenticate_user!
  before_action :check_if_sending_to_self, only: :create
  before_action :load_requested_user, only: :create
  before_action :check_if_already_friends, only: :create
  before_action :check_if_already_sent_request, only: :create
  before_action :check_if_received_request, only: :create
  before_action :friend_request_exists, only: :destroy
  before_action :load_request, only: :destroy

def create
  friend_request = FriendRequest.new(user: current_user, friend: @requestee)
  if friend_request.save
    flash[:success] = "request sent."
  else
    flash[:danger] = "request failed."
  end
  redirect_to @requestee

end

  def destroy
    if current_user == @requestee
      @friend_request.destroy
      flash[:notice] = "request rejected"
    elsif current_user == @requester
      @friend_request.destroy
      flash[:notice] = "request cancelled"
    else
      flash[:danger] = "unauthorized"
    end
    redirect_to @requestee


  end

  def received
    @users = current_user.friends_to_confirm.paginate(page: params[:page], per_page: 10)

  end

  def sent
    @users = current_user.friends_pending.paginate(page: params[:page], per_page: 10)

  end

  private

  def check_if_sending_to_self
    if current_user==User.find(params[:id])
      flash[:danger] = "You cannot send a friend request to yourself."
      redirect_to current_user
    end
  end

  def load_requested_user
    @requestee = User.find(params[:id])
  end

  def check_if_already_friends
    if Friendship.exists?(user: current_user.id, friend: params[:id])
      flash[:danger] = "You are already friends."
      redirect_to @requestee
    end
  end

  def check_if_already_sent_request
    if FriendRequest.exists?(user_id: current_user.id, friend_id: @requestee.id)
      flash[:danger] = "You already have a pending request for #{@requestee.username}."
      redirect_to @requestee
    end
  end

  def check_if_received_request
    if FriendRequest.exists?(friend_id: current_user.id, user_id: @requestee.id)
     flash[:danger] = "request already received"
      redirect_to current_user
    end
  end

  def friend_request_exists
    unless FriendRequest.exists?(id: params[:id]) || params[:id].nil?
      flash[:danger] = "invalid link."
      redirect_to current_user
    end
  end

  def load_request
    @friend_request = FriendRequest.find(params[:id])
    @requester = @friend_request.user
    @requestee = @friend_request.friend
  end


end
