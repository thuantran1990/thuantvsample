class User < ApplicationRecord
	has_many :microposts, dependent: :destroy
	has_many :active_relationships, class_name: Relationship.name,
									foreign_key: "follower_id",
									dependent: :destroy
	has_many :passive_relationships, class_name: Relationship.name,
									foreign_key: "followed_id",
									dependent: :destroy
	has_many :following, through: :active_relationships, source: :followed
	has_many :followers, through: :passive_relationships, source: :follower

	attr_accessor :remember_token
	before_save :downcase_email
	validates :date_of_birth, presence: true, if: :for_date_of_birth
	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255 },
		format: { with: VALID_EMAIL_REGEX },uniqueness: true
	has_secure_password
	validates :password, presence: true, length: { minimum: 6 },allow_nil: true	

	def current_user?(user)
		user && user == self
	end

	class << self
# Returns the hash digest of the given string.
		def digest(string)
			cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
			BCrypt::Engine.cost
			BCrypt::Password.create(string, cost: cost)
		end
# Returns a random token.
		def new_token
			SecureRandom.urlsafe_base64
		end
	end

	def remember
		self.remember_token = User.new_token
		update_attributes remember_digest: User.digest(remember_token)
	end
	
	def authenticated?(remember_token)
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end

		# Forgets a user.
	def forget
			update_attributes remember_digest: nil
	end

	def password_reset_expired?
		reset_sent_at < 2.hours.ago
	end

	def feed
		following_ids = "SELECT followed_id FROM relationships
						WHERE follower_id = :user_id"
		Micropost.where("user_id IN (#{following_ids})
						OR user_id = :user_id", user_id: id)
	end
	# Follows a user.
	def follow(other_user)
		following << other_user
	end
		# Unfollows a user.
	def unfollow(other_user)
		following.delete(other_user)
	end
	# Returns true if the current user is following the other user.
	def following?(other_user)
		following.include?(other_user)
	end
	
	private
 	 def downcase_email
    	self.email = email.downcase 
 	 end

 	 def for_date_of_birth
 	 	if date_of_birth <= Date.current
 	 	else
		 	errors.add(:date_of_birth, 'mày đen từ tương lai à')
 	 	end
 	 end
end