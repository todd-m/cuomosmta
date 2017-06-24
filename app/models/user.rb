class User < ActiveRecord::Base
  validates_presence_of :user_id, :name
  
  validates_uniqueness_of :user_id
end
