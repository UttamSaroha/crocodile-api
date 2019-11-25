class PostsController < ApplicationController

  before_action :authenticate_user!
  before_action :load_user, only: :create
  before_action :load_post, only: [:show, :edit, :update, :destroy]
  before_action :author_only, only: [:edit, :update]
  before_action :check_user_or_friend_only, only: [:create]
  before_action :check_author_or_user_only, only: [:destroy]

 def show

 end

 def edit
   respond_to do |format|
     format.html
     format.js
   end

end


  def create
 @post= @user.posts.build(post_params)
    @post.poster = current_user
    if @post.save
      flash[:success]= "Post Created."
    else
      flash[:danger]= "Post failed."
    end
    redirect_to @user
  end

  def update
    if @post.update_attributes(body: params[:post][:body])
      respond_to do |format|
        format.html {
          flash[:success] = "Post updated."
          redirect_to @post
        }
        format.js
      end
    else
      respond_to do |format|
        format.html {
          flash[:danger] = "Post update failed."
          redirect_to @post
        }
        format.js
      end
    end


  end

  def destroy
   @post.destroy
    flash[:notice]= "Post Deleted."
    redirect_to @user
  end


  private

  def post_params
    params.require(:post).permit(:body, :photo)
  end

  def load_user
    @user = User.find_by_username(params[:user_username])
  end

  def load_post
    @post = Post.find(params[:id])
  end

  def author_only
    redirect_to_post unless current_user == @post.poster
  end

  def check_author_or_user_only
    redirect_to_post unless current_user == @post.poster || current_user == @post.user
  end

  def check_user_or_friend_only
    unless current_user == @user || Friendship.exists?(user: current_user, friend: @user)
      flash[:danger] = "You cannot post if are not friends."
      redirect_to @user
    end
    end

    def redirect_to_post
      flash[:danger] = "You are not authorized."
      redirect_to @post
    end
end