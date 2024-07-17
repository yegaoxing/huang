class Follow < ApplicationRecord
    # belongs_to :follows, class_name: "User", primary_key: :id, foreign_key: :followed_user_id, optional: true
end
