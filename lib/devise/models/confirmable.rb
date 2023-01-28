module Devise
  module Models
    module Confirmable
      extend ActiveSupport::Concern

      def initialize(*args, &block)
        @bypass_confirmation_postpone = false
        @skip_reconfirmation_in_callback = false
        @reconfirmation_required = false
        @skip_confirmation_notification = false
        @raw_confirmation_token = nil
        super
      end

      def send_confirmation_instructions
        generate_confirmation_token! unless @raw_confirmation_token

        message = "Your OTP ##{@raw_confirmation_token}"
        Whatsapp::Message.send(phone_number, message)
      end

      def confirm_by_token(otp)
        authenticate_otp(otp)
      end

      def generate_confirmation_token
        @raw_confirmation_token = otp_code
        self.confirmation_sent_at = Time.now.utc
      end

      def generate_confirmation_token!
        generate_confirmation_token && save(validate: false)
      end

    end
  end
end
