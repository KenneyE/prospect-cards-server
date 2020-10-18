require 'rails_helper'

RSpec.describe Mutations::SaveEmailPreferences, type: :graphql do
  let(:user) { create(:user) }
  let(:category) { 'seller_emails' }
  let(:subscribed) { false }
  let(:preference) { create(:email_preference, user: user, category: category) }

  let(:mutation) do
    '
      mutation saveEmailPreferences($emailPreferences: [EmailPreferenceInput!]!) {
        saveEmailPreferences(emailPreferences: $emailPreferences) {
          viewer {
            id
            emailPreferences {
              ...emailPreference
            }
          }
          message
        }
      }
      fragment emailPreference on EmailPreference {
        id
        category
        subscribed
      }
    '
  end
  let(:expected) do
    {
      saveEmailPreferences: {
        viewer: {
          id: user.id,
          emailPreferences: [
            { id: preference.id, category: category, subscribed: subscribed },
          ],
        },
        message: 'Preferences saved',
      },
    }
  end
  let(:variables) do
    { emailPreferences: [{ category: category, subscribed: subscribed }] }
  end

  context 'when unsubscribing' do
    it { expect_query_result(mutation, expected, variables: variables) }

    context 'when preferences does not exist' do
      let(:category) { 'something_else' }

      it 'creates new preference' do
        expect { execute_query(mutation, variables: variables) }.to change(
          EmailPreference,
          :count,
        ).by(1)
      end
    end
  end

  context 'when subscribing' do
    let(:subscribed) { true }

    it { expect_query_result(mutation, expected, variables: variables) }

    context 'when preference does not exist' do
      let(:category) { 'something_else' }

      it 'does NOT create new preference' do
        expect do
          execute_query(mutation, variables: variables)
        end.not_to change(EmailPreference, :count)
      end
    end
  end
end
