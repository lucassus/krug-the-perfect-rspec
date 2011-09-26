!SLIDE smaller

# use `let` and `let!`

    @@@ ruby
    # ...let there be let!

    describe BlogPost do
      let(:blog_post) do
        FactoryGirl.create(:post, :title => 'Hello')
      end

      it "does something" do
        blog_post.should ...
      end

      it "does something else" do
        blog_post.should ...
      end
    end

!SLIDE smaller

# Tricks with let

    @@@ ruby
    let(:product) { mock_model(Product) }

    describe "on POST to :create" do
      before do
        Product.stub(:new).and_return(product)
        product.stub(:save).and_return(success)

        post :create, :product => { 'name' => 'Test' }
      end

      context "on success" do
        let(:success) { true }

        it { should set_the_flash }
        it { should respond_with(:redirect) }
        it { should redirect_to(admin_product_path(product)) }
      end

      context "on failure" do
        let(:success) { false }

        it { should_not set_the_flash }
        it { should respond_with(:success) }
        it { should render_template(:new) }
      end
    end