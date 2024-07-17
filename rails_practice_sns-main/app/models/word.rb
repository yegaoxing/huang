class Word < ApplicationRecord

    belongs_to :user

    validates :word, presence: true, length: {maximum: 140}
    validates :reading, presence: true, length: {maximum: 140}
end
