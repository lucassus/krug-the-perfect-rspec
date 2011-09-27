!SLIDE title subsection bullets

# Why you don't like RSpec?

* ..yet another DSL?
* ..difficult to learn?
* ..WTF is `subject`?
* ..WTF is `let` or `let!`?

.notes Next: DSL or no DSL

!SLIDE small

# DSL or no DSL

    @@@ ruby
    # RSpec
    describe User do
      it "should be valid" do
        FactoryGirl.build(:user).should be_valid
      end
    end

    # versus

    # TestUnit
    class UserTest < Test::Unit::Case
      def test_user_validity
        assert FactoryGirl.build(:user).valid?
      end
    end

.notes Next: Better rspec example

[José Valim, DSL or no DSL](http://blog.plataformatec.com.br/2010/06/dsl-or-nodsl-at-euruko-2010)

[DHH Offended By RSpec, Says Test::Unit Is Just Great](http://www.rubyinside.com/dhh-offended-by-rspec-debate-4610.html)
