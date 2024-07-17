class User < ApplicationRecord
    has_secure_password

    has_many :posts
    has_many :likes
    has_many :words
    has_many :follow_users, class_name: "Follow", foreign_key: :follow_user_id
    has_many :follower_users, class_name: "Follow", foreign_key: :followed_user_id

    validates :name, {presence: true}
    validates :email, {presence: true, uniqueness: true}
end
