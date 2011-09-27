require 'spec_helper'

describe Admin::ProductsController do
  let(:ability) { dummy_ability }
  before do
    ability.can :manage, :all
    controller.stub(:current_ability).and_return(ability)
  end

  let(:product) { mock_model(Product, :to_param => ':id') }

  describe "on GET to :index" do
    before do
      # Product.order('created_at').page(params[:page]).per(10)
      Product.stub_chain(:order, :page, :per).and_return([])
      get :index
    end

    it { should respond_with(:success) }
    it { should_not set_the_flash }
    it { should render_template(:index) }
    it { should assign_to(:products) }
  end

  describe "on GET to :show" do
    before do
      Product.stub(:find).and_return(product)
      product.stub(:subscriptions).and_return([])

      get :show, :id => product.to_param
    end

    it "should find the product" do
      Product.should have_received(:find).with(product.to_param)
    end

    it "should find product's subscriptions" do
      product.should have_received(:subscriptions)
    end

    it { should respond_with(:success) }
    it { should_not set_the_flash }
    it { should render_template(:show) }
    it { should assign_to(:product).with(product) }
  end

  describe "on GET to :new" do
    before do
      Product.stub(:new).and_return(product.as_new_record)
      get :new
    end

    it "should create a new product instance" do
      Product.should have_received(:new)
    end

    it { should respond_with(:success) }
    it { should_not set_the_flash }
    it { should render_template(:new) }
    it { should assign_to(:product).with(product) }
  end

  describe "on GET to :edit" do
    before do
      Product.stub(:find).and_return(product)
      get :edit, :id => product.to_param
    end

    it "should find the product" do
      Product.should have_received(:find).with(product.to_param)
    end

    it { should respond_with(:success) }
    it { should_not set_the_flash }
    it { should render_template(:edit) }
    it { should assign_to(:product).with(product) }
  end

  describe "on POST to :create" do
    let(:attributes) { { 'service_name' => 'Test' } }
    let(:success) { true }

    before do
      Product.stub(:new).and_return(product.as_new_record)
      product.stub(:save).and_return(success)

      post :create, :product => attributes
    end

    it "should create a new product instance" do
      Product.should have_received(:new).with(attributes)
    end

    it "should try to save a product" do
      product.should have_received(:save)
    end

    context "with valid attributes" do
      let(:success) { true }

      it { should assign_to(:product).with(product) }
      it { should set_the_flash }
      it { should respond_with(:redirect) }
      it { should redirect_to(admin_product_path(product)) }
    end

    context "with invalid attributes" do
      let(:success) { false }

      it { should assign_to(:product).with(product) }
      it { should_not set_the_flash }
      it { should respond_with(:success) }
      it { should render_template(:new) }
    end
  end

  describe "on PUT to :update" do
    let(:attributes) { { 'service_name' => 'test' } }
    let(:success) { true }

    before do
      Product.stub(:find).and_return(product)
      product.should_receive(:update_attributes).with(attributes).and_return(success)

      put :update, :id => product.to_param, :product => attributes
    end

    it "should find a product" do
      Product.should have_received(:find).with(product.to_param)
    end

    it "should try to save a product" do
      product.should have_received(:update_attributes).with(attributes)
    end

    context "with valid attributes" do
      let(:success) { true }

      it { should assign_to(:product).with(product) }
      it { should set_the_flash }
      it { should respond_with(:redirect) }
      it { should redirect_to(admin_product_path(product)) }
    end

    context "with invalid attributes" do
      let(:success) { false }

      it { should assign_to(:product).with(product) }
      it { should_not set_the_flash }
      it { should respond_with(:success) }
      it { should render_template(:edit) }
    end
  end

  describe "on DELETE do :destroy" do
    before do
      Product.stub(:find).and_return(product)
      product.stub(:destroy)

      delete :destroy, :id => product.to_param
    end

    it "should find the product" do
      Product.should have_received(:find).with(product.to_param)
    end

    it "should destroy the product" do
      product.should have_received(:destroy)
    end

    it { should assign_to(:product).with(product) }
    it { should set_the_flash }
    it { should respond_with(:redirect) }
    it { should redirect_to(admin_products_path) }
  end

end
