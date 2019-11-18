class UserProfile < ApplicationRecord
  has_secure_password
  has_many :share_posts

  validates :email, presence: true, uniqueness: true
end
