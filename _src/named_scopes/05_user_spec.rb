describe User do

  # for more details see: ./features/domain/user_unsubscribed_products.feature
  describe "#unsubscribed_products" do
    specify { subject.unsubscribed_products.should be_an_instance_of(ActiveRecord::Relation) }
  end

end
