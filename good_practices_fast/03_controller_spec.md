!SLIDE smaller

# Fast controller example

    @@@ ruby
    let(:user) { mock_model(User) }

    describe "on GET to :index" do
      before do
        User.stub(:all).and_return([])
        get :index
      end

      it { should respond_with(:success) }
      it { should_not set_the_flash }
      it { should render_template(:index) }
      it { should assign_to(:users) }
    end

## ..more code samples
