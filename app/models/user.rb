class User < ActiveRecord::Base
  has_many :messages
  has_many :comments
  has_many :syncs
end
