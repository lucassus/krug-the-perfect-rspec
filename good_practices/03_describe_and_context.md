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
        context 'on success'
        context 'on failure'
      end
    end

.notes Next: spec for model

!SLIDE smaller

# Spec for the model, basic structure

    @@@ ruby
    describe User do
      subject { Factory(:user) }

      describe "database table" do
        it { should have_db_column('email') }
      end

      describe "associations" do
        it { should have_many(:posts) }
      end

      describe "validations" do
        it { should validate_presence_of(:email) }
        it { should validate_uniqueness_of(:email) }
      end

      describe "scopes" do
        describe ".bloked"
        describe ".paginated"
      end

      describe "#full_name"
    end

.notes Next: use the right matcher

