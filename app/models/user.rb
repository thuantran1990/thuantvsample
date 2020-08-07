class User < ApplicationRecord
	before_save :downcase_email
	validates :date_of_birth, presence: true, if: :for_date_of_birth
	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255 },
		format: { with: VALID_EMAIL_REGEX },uniqueness: true
	has_secure_password
	validates :password, presence: true, length: { minimum: 6 }		
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