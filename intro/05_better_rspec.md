!SLIDE small

# Better RSpec example #

    @@@ ruby
    # RSpec
    describe User do
      it "should be valid" do
        FactoryGirl.build(:user).should be_valid
      end
    end

    # versus

    # RSpec
    describe User do
      subject { FactoryGirl.build(:user) }
      it { should be_valid }
    end

## ..and the question is.. who's the winner?

.notes Next: event better espec example

!SLIDE smaller

# ..even better RSpec example

    @@@ ruby
    # RSpec
    describe User, "a new record when login is set to 'anakin'" do
      let(:login) { 'anakin' }

      subject { Factory.build(:user, :login => login) }

      it { should be_valid } # subject.valid?
      it { should_not be_persisted } # subject.persisted?
      its(:login) { should == 'anakin' }

      context "when login is set to 'vader'" do
        let(:login) { 'vader' }
        its(:login) { should == 'vader' }
      end

      # ... an so on
    end

.notes Next: tests output

## Imagine how many lines of code you will have to write in bare TestUnit...

!SLIDE small

# Test output #

## TestUnit

    .....

## RSpec

### (with `--format documentation` option)

    User
      a new record when login is set to 'anakin'
        should be valid
        it should not be persisted
        login
          should == 'anakin'
        when login is set to 'vader'
          login
            should == 'vader'

.notes Next: Good practices (clean specs)

