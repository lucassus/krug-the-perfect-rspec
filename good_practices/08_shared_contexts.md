  class Subscription < ActiveRecord::Base
    STATUS_ACTIVE = 'active'
    STATUS_CANCELLED = 'cancelled'

    def self.with_status(*statuses)
      where("status IN (?)", statuses)
    end
  end

    describe "#with_status" do
      let!(:active_subscription) { FactoryGirl.create(:active_subscription) }
      let!(:cancelled_subscription) { FactoryGirl.create(:cancelled_subscription) }

      def self.when_status(*statuses, &ctx_block)
        ctx = context "when status is #{statuses.join('or ')}" do
          let(:result) { Subscription.with_status(*statuses) }
        end
        ctx.class_eval(&ctx_block)
      end

      when_status(Subscription::STATUS_ACTIVE) do
        specify { result.should have(1).item }
        specify { result.should include(active_subscription) }
      end

      when_status(Subscription::STATUS_ACTIVE, Subscription::STATUS_CANCELLED) do
        specify { result.should have(2).items }
        specify { result.should include(active_subscription) }
        specify { result.should include(cancelled_subscription) }
      end
    end
