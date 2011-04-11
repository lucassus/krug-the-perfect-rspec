!SLIDE title-slide

# Good practices #

!SLIDE small

# Describe what you are doing...

    @@@ ruby
    describe User do

      describe '.authenticate' do
      end

      describe '.admins' do
      end

      describe '#admin?' do
      end

      describe '#name' do
      end

    end

!SLIDE smaller

# Then establish the #context...

    @@@ ruby
    class SessionsController < ApplicationController

      def create
        user = User.authenticate(params)

        if user.present?
          # do something
        else
          # do something different
        end
      end

    end

    describe SessionsController do
      describe '#create' do
        context 'when create are valid'
        context 'when create are not valid'
      end
    end

!SLIDE

# Run specs to confirm readability

## Always run your specs with the ‘--format’ option set to ‘documentation’
### (in RSpec 1.x the –format options are ‘nested’ and ‘specdoc’)

!SLIDE smaller

# :it only expects one thing

    @@@ ruby
    describe UsersController, '#create' do
      it 'creates a new user' do
        User.count.should == @count + 1
        flash[:notice].should be
        response.should redirect_to(user_path(assigns(:user)))
      end
    end

    # vs.

    describe UsersController, '#create' do
      it 'creates a new user' do
        User.count.should == @count + 1
      end

      it 'sets a flash message' do
        flash[:notice].should be
      end

      it "redirects to the new user's profile" do
        response.should redirect_to(user_path(assigns(:user)))
      end
    end

!SLIDE bullets incremental

# :it only expects one thing, but why?

* I'll show you later why...

!SLIDE smaller

# Use the right matcher

## In case of failure

    @@@ ruby
    specify { user.valid?.should == true }

    # generates the following specdoc

    'User should == true' FAILED
      expected: true,
      got: false (using ==)

## while

    @@@ ruby
    specify { user.should be_valid }

    # generates the following specdoc

    'User should be valid' FAILED
      expected valid? to return true, got false

!SLIDE smaller

# Use shortcuts `specify`, `it` and `subject`

    @@@ ruby
    it "should be valid" do
      @user.should be_valid
    end

    # versus

    it { @user.should be_valid }

!SLIDE smaller

# Use shortcuts `specify`, `it` and `subject`

    @@@ ruby
    it "should have 422 status code if an unexpected params will be added" do
      response.should respond_with 422
    end

    # versus

    context "when not valid" do
      it { should respond_with 422 }
    end

!SLIDE smaller

# Use shortcuts `specify`, `it` and `subject`

    @@@ ruby
    it "should have 200 status code if logged in" do
      response.should respond_with 200
    end

    # versus

    context "when logged in" do
      it { should respond_with 200 }
    end

!SLIDE bullets incremental

# use `let` and `let!`

* `let` makes an instance method, returns lazily-evaluated block
* `let` shows you who the players are
* gets rid of the `before` block

!SLIDE small

# use `let` and `let!`, but why?

    @@@ ruby
    # it all starts simply enough...

    describe BlogPost do
      it "does something" do
        blog_post = BlogPost.create :title => 'Hello'
        blog_post.should ...
      end
    end

!SLIDE small

# use `let` and `let!`, but why?

    @@@ ruby
    # but then comes the duplication...

    describe BlogPost do
      it "does something" do
        blog_post = BlogPost.create :title => 'Hello'
        blog_post.should ...
      end

      it "does something else" do
        blog_post = BlogPost.create :title => 'Hello'
        blog_post.should ...
      end
    end

!SLIDE small

# use `let` and `let!`, but why?

    @@@ ruby
    # so you refactor to instance variables...

    describe BlogPost do
      before do
        @blog_post = BlogPost.create :title => 'Hello'
      end

      it "does something" do
        @blog_post.should ...
      end

      it "does something else" do
        @blog_post.should ...
      end
    end

!SLIDE small

# use `let` and `let!`, but why?

    @@@ ruby
    # ...let there be let!

    describe BlogPost do
      let(:blog_post) { BlogPost.create :title => 'Hello' }

      it "does something" do
        blog_post.should ...
      end

      it "does something else" do
        blog_post.should ...
      end
    end

!SLIDE bullets incremental

# [Use shoulda matchers](http://robots.thoughtbot.com/post/159805987/speculating-with-shoulda)

* comes from the land of Test::Unit
* powerful/handy/high-level macros
* many matchers now available in RSpec
* validate_presence_of, validate_format_of, ensure_length_of, have_many...
* just add a shoulda gem dependency

!SLIDE small

# Use shoulda, example

    @@@ ruby
    # the model
    class User < ActiveRecord::Base
      belongs_to :account
      haves_many :posts

      validates_presence_of :email
      allows_values_for :email, "test@example.com"
    end

    # ..and the corresponding spec
    describe User do
      it { should belong_to(:account) }
      it { should have_many(:posts) }

      it { should validate_presence_of(:email) }
      it { should allow_value("test@example.com").for(:email) }
    end

!SLIDE small

# Use shoulda, another example

    @@@ ruby
    it 'should validate presence of title' do
      lambda do
        p = BlogPost.create(:title => nil, :body => 'foo...')
        p.errors.on(:title).should_not be_nil
      end.should_not change { BlogPost.count }
    end

    # vs.

    describe BlogPost do
      it { should validate_presence_of(:title) }
    end

!SLIDE bullets incremental

# Shared behavior

* express shared behaviors in a compact way
* reuse sets of examples
* don't repeat yourself

!SLIDE smaller

# Use shared examples

    @@@ ruby
    shared_examples_for "a collection" do
      let(:collection) { described_class.new([7, 2, 4]) }

      describe "#include?" do
        context "with an item that is in the collection" do
          it "returns true" do
            collection.include?(7).should be_true
          end
        end

        context "with an item that is not in the collection" do
          it "returns false" do
            collection.include?(9).should be_false
          end
        end
      end
    end

    describe Array do
      it_behaves_like "a collection"
    end

    describe Set do
      it_behaves_like "a collection"
    end
