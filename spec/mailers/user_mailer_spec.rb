require 'rails_helper'

RSpec.describe UserMailer do
  let(:user) { FactoryGirl.create(:user)  }

  let(:culture) { user.culture }

  describe '#reset_password_instructions' do
    # We need to get the raw token generated by devise, not the one saved in
    # the database.
    let(:reset_password_token) { user.send(:set_reset_password_token) }

    let(:mail) do
      described_class.reset_password_instructions(user, reset_password_token)
    end

    let(:content) do
      I18n.locale = culture

      ResetPasswordInstructions.new(user, reset_password_token)
    end

    it_behaves_like 'a mail with', :reset_password_instructions,
      greets_user: true,
      labels:      [:details, :link, :notice],
      attributes:  [:reset_password_url]
  end

  describe '#email_verification_instructions' do
    let(:mail) { described_class.email_verification_instructions(user) }

    before do
      user.generate_email_verification_token!
    end

    let(:content) do
      I18n.locale = culture

      EmailVerificationInstructions.new(user)
    end

    it_behaves_like 'a mail with', :email_verification_instructions,
      greets_user: true,
      labels:      [:details, :link, :notice],
      attributes:  [:email_verification_url]
  end

  describe '#notifications_informations' do
    let(:notifications) { FactoryGirl.create_list(:notification, 5) }

    let(:user) { notifications.first.user }

    let(:mail) { described_class.notifications_informations(user, notifications) }

    let(:content) do
      I18n.locale = culture

      NotificationsInformations.new(user, notifications)
    end

    it_behaves_like 'a mail with', :notifications_informations,
      greets_user: true, labels: [:details], attributes: []

    [:description, :url].each do |attribute|
      it "assigns the notifications #{attribute}" do
        content.notifications.each do |notification|
          expect(mail.body.encoded).to include(notification.public_send(attribute))
        end
      end
    end
  end
end
