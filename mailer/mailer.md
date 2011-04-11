!SLIDE title-slide

# Spec for Rails mailers
## ...an example from the real life

!SLIDE smaller

    @@@ ruby
    class OrderMailer < ActionMailer::Base
      default :from => 'support@store.com'

      def confirm(order)
        @order = order

        invoice = Invoice.new(@order)
        attachments["Invoice-#{@order.number}.pdf"] = invoice.to_pdf

        mail(:to => @order.email, :subject => 'Order confirmation')
      end
    end

!SLIDE smaller

# Spec for mailer, bad example

    @@@ ruby
    describe OrderMailer do
      describe "#confirm" do
        before :all do
          @order = Factory(:order, :email => 'some@email.com')
          Factory(:line_item, :order => @order, :quantity => 1, :product => Factory(:product, :name => 'ThinkPad T410s'))
          Factory(:line_item, :order => @order, :quantity => 2, :product => Factory(:product, :name => 'Amazon Kindle 3G'))
        end

        it "should send an email successfully" do
          mail = OrderMailer.confirm(@order)

          mail.subject.should == 'Order confirmation'
          mail.from = ['support@store.com']
          mail.to.should == ['some@email.com']
    # ...to be continued

!SLIDE smaller

#  Bad mailer example continue...

    @@@ ruby
      # ...continuation
          mail_body = mail.body.encoded
          mail_body.should include('Dear Customer')
          mail_body.should include('Please review and retain the following order information for your records')
          mail_body.should include('Thank you for your business.')

          @order.line_items.each do |item|
            mail_body.should include("#{item.product.name} x#{item.quantity}")
          end

          mail_body.should include("Total price: $#{@order.total_price}")

          attachments = mail.attachments
          attachments.should have(1).item
          attachments.first.filename.should == "Invoice-#{@order.number}.pdf"

          expect { mail.deliver }.to change(ActionMailer::Base.deliveries, :size).by(1)
        end
      end
    end

!SLIDE smaller

# Better example

    @@@ ruby
    describe OrderMailer do
      describe "#confirm" do
        let(:order) { Factory(:order, :email => 'client@email.com') }
        before :all do
          Factory(:line_item, :order => order, :quantity => 1, :product => Factory(:product, :name => 'ThinkPad T410s'))
          Factory(:line_item, :order => order, :quantity => 2, :product => Factory(:product, :name => 'Amazon Kindle 3G'))
        end

        it "should render an email successfully" do
          expect { OrderMailer.confirm(order) }.to_not raise_error
        end

        describe :mail do
          let(:mail) { OrderMailer.confirm(order) }
          subject { mail }

          its(:subject) { should == 'Order confirmation' }
          its(:from) { should == ['support@store.com'] }
          it("should be sent to the consuner") do
            subject.to.should == ['client@email.com']
          end

          # Test the body of the sent email contains what we expect it to
          describe :body do
            subject { mail.body.encoded }

            it { should include('Dear Customer') }
            it { should include('Please review and retain the following order information for your records') }
            it { should include('Thank you for your business.') }

            it "should include ordered products names with quantity and price" do
              order.line_items.each do |item|
                subject.should include("#{item.product.name} x#{item.quantity}")
              end
            end

            it "should include total price" do
              subject.should include("Total price: $#{order.total_price}")
            end

            describe :attachments do
              subject { mail.attachments }

              it { should have(1).item }

              it "should contain a pdf file with an invoice" do
                subject.first.filename.should == "Invoice-#{order.number}.pdf"
              end
            end
          end

          describe "#deliver" do
            it "should add the email to the delivery queue" do
              expect { subject.deliver }.to change(ActionMailer::Base.deliveries, :size).by(1)
            end
          end
        end
      end
    end

!SLIDE

# Compare test outputs

!SLIDE smaller

# Bad mailer example, spec output

    $ rspec spec/mailers/order_mailer_spec.rb --format documentation

    OrderMailer
      #confirm
        should sent an email successfully

!SLIDE smaller

# Good example, spec output

      $ bundle exec rspec spec/mailers/order_mailer_spec.rb --fd

      OrderMailer
        #confirm
          should render an email successfully
          mail
            should be sent to the consumer
            subject
              should == "Order confirmation"
            from
              should == ["support@store.com"]
            body
              should include "Dear Customer"
              should include "Please review and retain the following order information for your records"
              should include "Thank you for your business."
              should include ordered products names with quantity and price
              should include total price
              attachments
                should have 1 item
                should contain a pdf file with an invoice
            #deliver
              should add the email to the delivery queue

!SLIDE smaller

# In case of error

      OrderMailer
        #confirm
          should send an email successfully (FAILED - 1)

      Failures:

        1) OrderMailer#confirm should send an email successfully
           Failure/Error: attachments.should have(1).item
             expected 1 item, got 0
           # ./spec/mailers/bad_order_mailer_spec.rb:30:in `block (3 levels) in <top (required)>'


!SLIDE smaller

# In case of error

      OrderMailer
        #confirm
          should render an email successfully
          mail
            should be sent to the consuner
            subject
              should == "Order confirmation"
            from
              should == ["support@store.com"]
            body
              should include "Dear Customer"
              should include "Please review and retain the following order information for your records"
              should include "Thank you for your business."
              should include ordered products names with quantity and price
              should include total price
              attachments
                should have 1 item (FAILED - 1)
                should contain a pdf file with an invoice (FAILED - 2)
            #deliver
              should add the email to the delivery queue

      Failures:

        1) OrderMailer#confirm mail body attachments
           Failure/Error: it { should have(1).item }
             expected 1 item, got 0
           # ./spec/mailers/order_mailer_spec.rb:47:in `block (6 levels) in <top (required)>'

        2) OrderMailer#confirm mail body attachments should contain a pdf file with an invoice
           Failure/Error: subject.first.filename.should == "Invoice-#{order.number}.pdf"
           NoMethodError:
             undefined method `filename' for nil:NilClass
           # ./spec/mailers/order_mailer_spec.rb:50:in `block (6 levels) in <top (required)>'