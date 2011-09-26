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

# Mailer spec

    @@@ ruby
    describe OrderMailer do
      describe "#confirm" do
        let(:order) # create an order and example products

        it "should render an email successfully" do
          expect { OrderMailer.confirm(order) }.to_not raise_error
        end

        describe "email" do
          let(:mail) { OrderMailer.confirm(order) }
          subject { mail }

          its(:subject) { should == 'Order confirmation' }
          its(:from) { should == ['support@store.com'] }
          it("should be sent to the consumer") do
            subject.to.should == ['client@email.com']
          end

         # see next slide

!SLIDE very-small

# Better example, cnt.

    @@@ ruby
          # Test the body of the sent email contains what we expect it to
          describe "email's body" do
            subject { mail.body.encoded }

            it { should include('Dear Customer') }
            it { should include('Thank you for your business.') }

            it "should include ordered products names with quantity and price" do
              order.line_items.each do |item|
                subject.should include("#{item.product.name} x#{item.quantity}")
              end
            end

            it "should include total price" do
              subject.should include("Total price: $#{order.total_price}")
            end
          end

          describe "attachments" do
            subject { mail.attachments }

            it { should have(1).item }

            it "should contain a pdf file with an invoice" do
              subject.first.filename.should == "Invoice-#{order.number}.pdf"
            end
          end

          describe "#deliver" do
            it "should add the email to the delivery queue" do
              expect do
                subject.deliver
              end.to change(ActionMailer::Base.deliveries, :size).by(1)
            end
          end
        end
      end
    end

!SLIDE specdoc

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

!SLIDE specdoc

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
