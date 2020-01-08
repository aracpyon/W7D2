class User < ApplicationRecord
    validates :email, :session_token, presence: true, uniqueness: true
    validates :password, length: {minimum: 6}, allow_nil: true
    validates :password_digest, presence: true
    

    after_initialize :ensure_session_token #before_validations, make sure to have session_token
    attr_reader :password #Q. can this go before after_initailize

    def self.generate_session_token #generate session token here
        SecureRandom::urlsafe_base64(16)
    end

    def self.find_by_credentials(email, password)
        user = User.find_by(email: email) #you can find the user beacuse eamil is unique
        return nil unless user && user.is_password?(password)
        user #when do you create invar? 
    end

    def reset_session_token!
        self.session_token = User.generate_session_token
        self.session_token
    end

    def ensure_session_token #if session_token is nil, generate it, and if there is return self.session_token
        self.session_token ||= User.generate_session_token
    end

    def password=(password) #when you register or reset your password
        @password = password
        self.password_digest = BCrypt::Password.create(password)
        #as you set password, you get password_digest with newly created BCrypt. 
    end

    def is_password?(password) #you use this when you login 
        bcrypted_password = BCrypt::Password.new(self.password_digest)#becrypting the password_digest(changing the string into bcrypt object) because password_digest is a string right now
        bcrypted_password.is_password?(password) 
        #(is_password is a builtin in the gem. This is_password belongs to BCrypt, which is built in the bcrypt gem, but User instance.is_password? is our manual methoud
    end


end
