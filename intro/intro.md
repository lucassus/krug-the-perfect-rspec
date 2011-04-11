!SLIDE title-slide

# The perfect RSpec #

!SLIDE bullets incremental

# Agenda #

* Why don't you like RSpec?
* Some good practices
* Shoulda matchers for RSpec
* Spec for Rails mailer
* Spec for Rails model
* Spec for Rails controller

!SLIDE bullets incremental

# Why you don't like RSpec? #

* ..yet another DSL?
* ..difficult to learn?
* ..WTF is `subject`?
* ..WTF is `let` or `let!`?

!SLIDE small

# [José Valim, DSL or no DSL](http://blog.plataformatec.com.br/2010/06/dsl-or-nodsl-at-euruko-2010) #

    @@@ ruby
    # RSpec
    describe User do
      it "should be valid" do
        Factory.build(:user).should be_valid
      end
    end

    # versus

    # TestUnit
    class UserTest < Test::Unit::Case
      def test_user_validity
        assert Factory.build(:user).valid?
      end
    end

!SLIDE small

# ..better RSpec example #

    @@@ ruby
    # RSpec
    describe User do
      subject { Factory.build(:user) }
      it { should be_valid }
    end

!SLIDE small

# ..better RSpec example #

    @@@ ruby
    # RSpec
    describe User do
      subject { Factory.build(:user, :login => 'anakin') }

      it { should be_valid }
      it { should_not be_persisted }
      its(:login) { should == 'anakin' }

      # ... an so on
    end

## Imagine how many lines of code you will have to write in bare TestUnit...

!SLIDE small

# Test output #

## TestUnit

    ....

## RSpec

### (with `--format documentation` option)

    User
      should be valid
      it should not be persisted
      login
        should == 'anakin'
