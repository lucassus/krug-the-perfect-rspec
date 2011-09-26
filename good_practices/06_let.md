!SLIDE smaller

# use `let` and `let!`

    @@@ ruby
    describe BlogPost do
      it "does something" do
        blog_post = FactoryGirl.create(:post, :title => 'Hello')
        blog_post.should ...
      end

      it "does something else" do
        blog_post = FactoryGirl.create(:post, :title => 'Hello')
        blog_post.should ...
      end
    end

!SLIDE smaller

# use `let` and `let!`, but why?

    @@@ ruby
    # so you refactor to instance variables...

    describe BlogPost do
      before do
        @blog_post = FactoryGirl.create(:post, :title => 'Hello')
      end

      it "does something" do
        @blog_post.should ...
      end

      it "does something else" do
        @blog_post.should ...
      end
    end

!SLIDE smaller

# use `let` and `let!`, but why?

    @@@ ruby
    # ...let there be let!

    describe BlogPost do
      let(:blog_post) do
        FactoryGirl.create(:post, :title => 'Hello')
      end

      it "does something" do
        blog_post.should ...
      end

      it "does something else" do
        blog_post.should ...
      end
    end
