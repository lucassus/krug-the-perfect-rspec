describe User do

  describe "#unsubscribed_products" do
    subject { stub_model(User) }
    before do
      subject.stub(:has_active_subscriptions?).and_return(has_subscriptions)
    end

    context "when user hasn't any active subscriptions" do
      let(:has_subscriptions) { false }
      before do
        Product.stub(:scoped)
        subject.unsubscribed_products
      end

      it "should return all products" do
        Product.should have_received(:scoped)
      end
    end

    context "when user has active subscriptions" do
      let(:has_subscriptions) { true }
      let(:subscribed_products_ids) { [1,2,3] }

      before do
        subject.stub(:subscribed_products_ids).and_return(subscribed_products_ids)
        subject.unsubscribed_products
      end

      it "should return filtered list of products" do
        subject.unsubscribed_products.where_values.should == ["id NOT IN (#{subscribed_products_ids.join(',')})"]
      end
    end
  end

end
