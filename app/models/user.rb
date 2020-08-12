class User < ApplicationRecord #  :timeoutable, and :omniauthable # Include default devise modules. Others available are:
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :trackable,
         :confirmable,
         :lockable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenyList
end
