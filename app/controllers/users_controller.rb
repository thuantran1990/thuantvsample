
class UsersController < ApplicationController
 	before_action :find_user, only: [:edit, :show, :update, :correct_user, :destroy]
	before_action :logged_in_user, only: [:index, :edit, :update]
	before_action :correct_user,only: [:edit, :update]
 	before_action :admin_user,only: [:destroy]

	def index
		@users = User.paginate(page: params[:page])
	end

	def show
		@microposts = @user.microposts.paginate(page: params[:page])

	end

	def new
		@user = User.new
	end
	def create
		@user = User.new user_params
		if @user.save
# Handle a successful save.
			flash[:success] = "Welcome to the Sample App!"
			redirect_to @user
		else
			render :new

		end
	end
	
	def edit
	
	end

	def update
		if @user.update(user_params)
		# Handle a successful update.
			flash[:success] = "Profile updated"
			redirect_to @user
		else
		render 'edit'
		end
	end

	def destroy
		@user.destroy
		flash[:success] = "User deleted"
		redirect_to users_url
	end

	def following
		@title = "Following"
		@user = User.find(params[:id])
		@users = @user.following.paginate(page: params[:page])
		render 'show_follow'
	end
	def followers
		@title = "Followers"
		@user = User.find(params[:id])
		@users = @user.followers.paginate(page: params[:page])
		render 'show_follow'
	end
	private
	def user_params
		params.require(:user).permit(:name, :email, :password,:password_confirmation,:date_of_birth,:gioi_tinh,:que_quan)
	end
	# Before filters
	
		# Confirms the correct user.
	def correct_user
		redirect_to(root_url) unless current_user.current_user?(@user)
	end

	def admin_user
		redirect_to(root_url) unless current_user.admin?
	end

	def find_user
		@user= User.find_by(id:params[:id])
		if @user.nil?
		 	flash[:danger] ="Do not find user"
		 	redirect_to root_path

		end
	end
end

