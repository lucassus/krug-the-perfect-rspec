!SLIDE smaller

# Spec for the model, basic structure

    @@@ ruby
    describe User do
      subject { Factory(:user) }

      describe "database table" do
        it do
          should have_db_column('email').of_type(:string).
            with_options(:null => false)
        end
      end

      describe "associations" do
        it { should have_many(:posts) }
      end

      describe "validations" do
        it { should validate_presence_of(:email) }
        it { should validate_uniqueness_of(:email) }
      end

      describe "scopes" do
      end

      describe "#full_name" do
      end
    end
