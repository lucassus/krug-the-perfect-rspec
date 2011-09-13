describe User do

  describe "#unsubscribed_products" do
    subject { FactoryGirl.create(:user) }

    let!(:product_one) { FactoryGirl.create(:product) }
    let!(:product_two) { FactoryGirl.create(:product) }
    let!(:product_three) { FactoryGirl.create(:product) }

    context "there is no products" do
      before { Product.delete_all }

      it "should return an empty list" do
        subject.unsubscribed_products.should be_empty
      end
    end

    context "when user has no subscriptions" do
      it "should return a list with all products" do
        results = subject.unsubscribed_products
        Product.all.each do |product|
          results.should include(product)
        end
      end
    end

    context "when user is subscribed to two products" do
      before do
        FactoryGirl.create(:subscription, :user => subject, :product => product_one)
        FactoryGirl.create(:subscription, :user => subject, :product => product_two)
      end

      it "should not include these products in the results" do
        results = subject.unsubscribed_products

        results.should include(product_three)
        results.should_not include(product_one)
        results.should_not include(product_two)
      end
    end

    context "when other user is subscribed to two products" do
      let(:other_user) { FactoryGirl.create(:user) }

      before do
        FactoryGirl.create(:subscription, :user => other_user, :product => product_one)
        FactoryGirl.create(:subscription, :user => other_user, :product => product_two)
        FactoryGirl.create(:subscription, :user => subject, :product => product_three)
      end

      it "should include there products in the results" do
        results = subject.unsubscribed_products

        results.should include(product_one)
        results.should include(product_two)
        results.should_not include(product_three)
      end
    end
  end

end
