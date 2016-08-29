class User < ApplicationRecord
  has_many :microposts
  validates presence: true
end
