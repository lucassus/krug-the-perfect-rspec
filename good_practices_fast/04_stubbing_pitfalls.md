!SLIDE smaller

# Stubbing pain number #1

    @@@ Ruby
    def index
      @followers_tweets = current_user.followers_tweets.limit(20)
      @recent_tweet = current_user.tweets.first
      @following = current_user.following.limit(5)
      @followers = current_user.followers.limit(5)
      @recent_favorite = current_user.favorite_tweets.first
      @recent_listed = current_user.recently_listed.limit(5)

      if current_user.trend_option == "worldwide"
        @trends = Trend.worldwide.by_promoted.limit(10)
      else
        @trends = Trend.filter_by(current_user.trend_option).limit(10)
      end
    end

[Rails Best Practices](http://www.codeschool.com/courses/rails-best-practices)

!SLIDE smaller

# Solution

    @@@ ruby
    def index
      @presenter = Tweets::IndexPresenter.new(current_user)
    end

    describe "on GET to :index" do
      let(:presenter) { mock('IndexPresenter') }
      before { Tweets::IndexPresenter.stubs(:new => presenter) }

      # etc.
    end

!SLIDE smaller

# Stubbing pain number #2

    @@@ ruby
    def show
      @user = User.find(params[:id])
      @subscriptions = @user.subscriptions_paginated(params[:page])
    end

    describe UsersController, "show" do
      let(:user) { mock_model(User, :subscriptions_paginated => []) }

      before do
        User.stub(:find => user)
        get :index, :id => user
      end

      # etc.
    end

# What will happen when I refactor User#subscriptions_paginated method?

!SLIDE smaller

# Solution

* Always write functional tests!
* Once again: always write functional tests!
  * Cumber, request specs, steak etc.
* ...or stub methods more carefully?

!SLIDE smaller

# Stubbing pain number #3

## code samples.. 
### a lot of code

!SLIDE

# Solution

* use common sense
* ..and learn about OOP design ;)

[Making ActiveRecord Models Thin](http://solnic.eu/2011/08/01/making-activerecord-models-thin.html)

[A Paperclip Refactoring Tale: Part One: Dependency Injection](http://robots.thoughtbot.com/post/9888374844/a-paperclip-refactoring-tale-part-one-dependency)

[The Secret to Rails OO Design](http://blog.steveklabnik.com/2011/09/06/the-secret-to-rails-oo-design.html)

[Extracting Domain Models: A Practical Exampl](http://blog.steveklabnik.com/2011/09/22/extracting-domain-models-a-practical-example.html)

