describe PaymentsController do

  describe "on POST to :create" do
    let(:attributes) { { 'product_id' => ':product_id', 'comments' => 'foobar' } }
    let(:success) { false }
    let(:gateway_success) { true }

    let(:token) { 'the paypal token' }
    let(:transaction) { mock('payment transaction') }
    let(:gateway_response) { mock('gateway_response', :success? => gateway_success, :token => token) }
    let(:paypal_gateway_url) { 'http://paypal.com/recurring' }

    before do
      Subscription.should_receive(:new).with(attributes).and_return(subscription.as_new_record)
      subscription.should_receive(:user=).with(user)
      subscription.should_receive(:product_id=).with(attributes['product_id'])
      subscription.stub(:save).and_return(success)

      controller.stub(:transaction_for => transaction)
      transaction.stub(:setup_agreement => gateway_response)
      transaction.stub(:paypal_url_for => paypal_gateway_url)
      transaction.stub(:description => 'sample subscription')

      post :create, :subscription => attributes
    end

    it "should try to save the subscription record" do
      subscription.should have_received(:save)
    end

    context "with valid attributes" do
      let(:success) { true }

      it "should create transaction object" do
        controller.should have_received(:transaction_for).with(subscription)
      end

      it "should send :setup_agreement request" do
        transaction.should have_received(:setup_agreement)
      end

      it { should assign_to(:subscription).with(subscription) }
      it { should respond_with(:redirect) }

      context "when gateway response is success" do
        let(:gateway_success) { true }

        it "should build paypal redirect url" do
          transaction.should have_received(:paypal_url_for).with(token)
        end

        it { should_not set_the_flash }
        it { should redirect_to(paypal_gateway_url) }
      end

      context "when gateway response is failure" do
        let(:gateway_success) { false }

        it { should set_the_flash }
        it { should redirect_to(subscriptions_path) }
      end
    end

    context "with invalid attributes" do
      let(:success) { false }

      it { should assign_to(:subscription).with(subscription) }
      it { should_not set_the_flash }
      it { should respond_with(:success) }
      it { should render_template(:new) }
    end
  end

end
