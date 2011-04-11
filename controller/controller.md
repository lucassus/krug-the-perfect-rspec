!SLIDE smaller

# Spec for the controller

    @@@ ruby
    describe Admin::UsersController do
      let(:resource) { Factory(:user) }

      describe "on PUT to :create" do
        context "with valid attributes" do
          before do
            post :create, :user => Factory.attributes_for(:user,
              :email => 'vader@deathstar.com',
              :first_name => 'Darth', :last_name => 'Vader')
          end

          it_should_behave_like "successful :create action"
        end

        context "with invalid attributes" do
          before { post :create, :user => {:email => 'invalid'} }

          it_should_behave_like "unsuccessful :create action"
        end
      end
    end

!SLIDE

# Where's the magic?

!SLIDE smaller

# Spec for the controller

    @@@ ruby
    let(:resource_model) { resource.class }
    let(:resource_name) { resource_model.to_s.underscore.to_s }
    def translated_flash_for(action) #... etc.

    shared_examples_for "successful :create action" do
      it { should assign_to(resource_name) }
      it { should set_the_flash.to(translated_flash_for(:create)) }
      it { should respond_with(:redirect) }
      it("should redirect to the :show resource action") do
        should redirect_to(:action => :show,
          :id => resource_model.last.to_param)
      end
    end

    shared_examples_for "unsuccessful :create action" do
      it { should respond_with(:success) }
      it { should assign_to(resource_name) }
      it { should_not set_the_flash }
      it { should render_template(:new) }
    end

!SLIDE

# Questions?
