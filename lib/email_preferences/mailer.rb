module EmailPreferences
  module Mailer
    def self.included(klass)
      klass.include InstanceMethods
      klass.extend ClassMethods
      klass.class_eval do
        attr_reader :subscriber

        class_attribute :action_categories
        self.action_categories = {}

        before_action :set_subscriber
      end
    end

    module InstanceMethods
      protected

      def _send_email
        return unless recipient_subscribed?
        super
      end

      private

      def current_action_category
        self.action_categories[action_name.to_sym] ||
          self.action_categories[:all]
      end

      def recipient_subscribed?
        EmailPreference.find_or_create_by(
          category: current_action_category,
          user: subscriber
        ).subscribed?
      end

      def set_subscriber
        if params[:subscriber_id].nil?
          raise(Errors::MissingSubscriber, 'Must provide subscriber to mailer')
        end

        @subscriber = User.find(params[:subscriber_id])
      end
    end

    module ClassMethods
      def categorize(meths = [], as:)
        actions = meths.empty? ? [:all] : meths
        actions.each { |action| self.action_categories[action.to_sym] = as }
      end
    end
  end
end