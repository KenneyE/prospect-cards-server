# typed: ignore
# Helper methods for testing mailers
module MailerHelpers
  def expect_enqueue_without_error(method, *arguments)
    expect_no_error(method, *arguments)
    expect_enqueued(method, *arguments)
  end
  alias enqueues_without_error expect_enqueue_without_error

  def expect_enqueued(method, *arguments)
    expect do
      described_class.public_send(method, *arguments).deliver_later
    end.to have_enqueued_job(ActionMailer::DeliveryJob)
  end

  def expect_no_error(method, *arguments)
    expect { mailer.public_send(method, *arguments) }.not_to raise_error
  end

  def stubbed_mailer
    message_delivery = instance_double(ActionMailer::MessageDelivery)
    allow(message_delivery).to receive(:deliver_later)
    message_delivery
  end
end
