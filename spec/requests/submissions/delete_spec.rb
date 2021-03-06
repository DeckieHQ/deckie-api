require 'rails_helper'

RSpec.describe 'Destroy event submission', :type => :request do
  let(:submission) { FactoryGirl.create(:submission) }

  before do
    delete submission_path(submission), headers: json_headers
  end

  it_behaves_like 'an action requiring authentication'

  context 'when user is authenticated' do
    let(:authenticate) { user }

    context "when submission doesn't exist" do
      let(:user) { FactoryGirl.create(:user) }

      let(:submission) { { id: 0 } }

      it { is_expected.to return_not_found }
    end

    context 'when user has no access to the submission' do
      let(:user) { FactoryGirl.create(:user) }

      it { is_expected.to return_forbidden }

      it "doesn't destroy the submission" do
        expect(submission.reload).to be_persisted
      end
    end

    context 'when subscribtion belongs to the user' do
      let(:user) { submission.profile.user }

      it { is_expected.to return_no_content }

      it 'destroys the submission' do
        expect(Submission.find_by(id: submission.id)).to be_nil
      end

      context 'when submissions is pending' do
        let(:submission) { FactoryGirl.create(:submission, :pending) }

        it { is_expected.to have_created_action(user.profile, submission.event, 'unsubmit') }
      end

      context 'when submissions is confirmed' do
        context 'when event becomes not ready after submission cancellation' do
          let(:submission) { FactoryGirl.create(:submission, :confirmed, :to_event_almost_ready) }

          it { is_expected.to have_created_action(user.profile, submission.event, 'leave') }

          it { is_expected.to have_created_action(user.profile, submission.event, 'not_ready') }
        end

        context "when event doesn't become not ready after submission cancellation" do
          let(:submission) { FactoryGirl.create(:submission, :confirmed, :to_event_ready) }

          it { is_expected.to have_created_action(user.profile, submission.event, 'leave') }

          it { is_expected.to_not have_created_action(user.profile, submission.event, 'not_ready') }
        end

        context 'when event was already not ready before submission cancellation' do
          let(:submission) { FactoryGirl.create(:submission, :confirmed, :to_event_not_ready) }

          it { is_expected.to have_created_action(user.profile, submission.event, 'leave') }

          it { is_expected.to_not have_created_action(user.profile, submission.event, 'not_ready') }
        end
      end

      # Test the service invokation. Therefore we don't need more tests here as
      # the service is heavily tested independantly.
      context 'when submission event is closed' do
        let(:submission) { FactoryGirl.create(:submission, :to_event_closed) }

        it { is_expected.to return_authorization_error(:event_closed) }
      end
    end
  end
end
