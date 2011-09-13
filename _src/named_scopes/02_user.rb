Class User < ActiveRecord::Base
  
  def unsubscribed_products
    if has_active_subscriptions?
      Product.where('id NOT IN (?)', subscribed_products_ids)
    else
      # just return all products
      Product.scoped
    end
  end

  def unsubscribed_products_paginated(page, order)
    unsubscribed_products.
      page(page).
      order(order).
      per(10)
  end

  private

  def subscribed_products_ids
    subscriptions.active.map(&:product_id)
  end

end
