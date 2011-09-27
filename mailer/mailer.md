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

         # see next slide..

!SLIDE very-small

# Better example, cnt.

    @@@ ruby
          # Test the body of the sent email contains what we expect it to
          describe "email's body" do
            subject { mail.body.encoded }

            it { should include('Dear Customer') }
            it { should include('Thank you for your business.') }

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

