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
    subject { user }
    it { should be_valid }

    # generates the following specdoc

    'User should be valid' FAILED
      expected valid? to return true, got false

[more in RSpec documentation](https://www.relishapp.com/rspec/rspec-expectations)

!SLIDE bullets

# [Use shoulda matchers](http://robots.thoughtbot.com/post/159805987/speculating-with-shoulda)

* many matchers now available in RSpec
* validate\_presence\_of, validate\_format\_of, ensure\_length\_of, have\_many...
* just add a shoulda gem dependency

!SLIDE smaller

# Use shoulda, example

    @@@ ruby
    # the model
    class User < ActiveRecord::Base
      belongs_to :account
      has_many :posts

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
