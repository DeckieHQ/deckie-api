require 'rails_helper'

RSpec.describe ActionNotifierJob, :type => :job do
  it 'uses the notifications queue' do
    expect(described_class.queue_name).to eq('notifications')
  end

  describe '#perform' do
    subject(:perform) { described_class.perform_now(action) }

    # We must create an action without notifications, otherwise the job will
    # fail because of the unique index [action_id, user_id] on table notifications.
    let(:action) do
      FactoryGirl.create(:action, :of_event_with_submissions, notify: :never)
    end

    let(:receivers) do
      Profile.where(id: action.receivers_ids).includes(:user)
    end

    context 'when receivers exists' do
      before { perform }

      it 'creates notifications for this action' do
        receivers.each do |receiver|
          expect(notification_of(receiver.user)).to be_present
        end
      end
    end

    context 'when receivers have been deleted' do
      before do
        receivers.destroy_all

        perform
      end

      it 'creates no notifications for this action' do
        expect(Notification.where(action_id: action.id)).to be_empty
      end
    end

    def notification_of(user)
      Notification.find_by!(user_id: user.id, action_id: action.id, viewed: false)
    end
  end
end
