!SLIDE smaller

# User, Product and Subscription

    @@@ ruby
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

!SLIDE smaller

# User#unsubscribed_products

!SLIDE smaller
# User#unsubscribed_products

    @@@ ruby
    def unsubscribed_products
      scope = Product.active

      if has_active_subscriptions?
        scope = scope.where('id NOT IN (?)', subscribed_products_ids)
      end

      scope
    end

!SLIDE small
# spec for User#unsubscribed_products ???

