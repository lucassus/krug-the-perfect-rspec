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
