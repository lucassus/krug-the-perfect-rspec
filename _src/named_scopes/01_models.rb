class User < ActiveRecord::Base
  has_many :subscriptions, :order => 'created_at DESC'
  has_many :products, :through => :subscriptions
end

class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :product

  # status (active, cancelled)
end

class Product < ActiveRecord::Base
  has_many :subscriptions

  # status (active, suspended)
end
