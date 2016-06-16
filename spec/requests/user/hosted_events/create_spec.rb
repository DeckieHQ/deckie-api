require 'rails_helper'

RSpec.describe 'User create hosted event', :type => :request do
  let(:params)       { Serialize.params(event_params, type: :events) }
  let(:event_params) { event.attributes }

  before do
    post user_hosted_events_path, params: params, headers: json_headers
  end

  it_behaves_like 'an action requiring authentication'

  context 'when user is authenticated' do
    let(:user) { FactoryGirl.create(:user_verified) }

    let(:authenticate) { user }

    include_examples 'check parameters for', :events

    context 'when attributes are valid' do
      let(:event) { FactoryGirl.build(:event) }

      let(:created_event) { user.hosted_events.last }

      it { is_expected.to return_status_code 201 }

      it 'creates a new event with permited parameters' do
        permited_params = event.slice(
          :title, :category, :min_capacity, :ambiance, :level, :capacity, :auto_accept,
          :short_description, :description, :street, :postcode, :city, :state,
          :country
        )
        expect(created_event).to have_attributes(permited_params)

        expect(created_event.begin_at).to equal_time(event.begin_at)
        expect(created_event.end_at).to   equal_time(event.end_at)
      end

      it 'returns the event attributes' do
        expect(response.body).to equal_serialized(created_event)
      end

      it 'grants the user with an achievement' do
        expect(user).to have_achievement('early-event')
      end
    end

    context 'when attributes are invalid' do
      let(:event) { Event.new }

      it { is_expected.to return_validation_errors :event }
    end

    context 'when user is not verified' do
      let(:user) { FactoryGirl.create(:user) }

      let(:params) {}

      it { is_expected.to return_authorization_error(:user_unverified) }

      it "doesn't create the event" do
        expect(user.hosted_events).to be_empty
      end
    end
  end
end
