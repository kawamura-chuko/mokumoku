# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'スコープ' do
    describe 'allowing_created_event_notification' do
      let!(:allowed_user) do
        user = create(:user)
        user.notification_timings << NotificationTiming.find_by!(timing: :created_event)
        user
      end
      let!(:not_allowed_user) { create(:user) }

      it '対象が正しいこと' do
        expect(User.allowing_created_event_notification).to include(allowed_user)
        expect(User.allowing_created_event_notification).not_to include(not_allowed_user)
      end
    end

    describe 'allowing_commented_to_event_notification' do
      let!(:allowed_user) do
        user = create(:user)
        user.notification_timings << NotificationTiming.find_by!(timing: :commented_to_event)
        user
      end
      let!(:not_allowed_user) { create(:user) }

      it '対象が正しいこと' do
        expect(User.allowing_commented_to_event_notification).to include(allowed_user)
        expect(User.allowing_commented_to_event_notification).not_to include(not_allowed_user)
      end
    end

    describe 'allowing_attended_to_event_notification' do
      let!(:allowed_user) do
        user = create(:user)
        user.notification_timings << NotificationTiming.find_by!(timing: :attended_to_event)
        user
      end
      let!(:not_allowed_user) { create(:user) }

      it '対象が正しいこと' do
        expect(User.allowing_attended_to_event_notification).to include(allowed_user)
        expect(User.allowing_attended_to_event_notification).not_to include(not_allowed_user)
      end
    end

    describe 'allowing_liked_event_notification' do
      let!(:allowed_user) do
        user = create(:user)
        user.notification_timings << NotificationTiming.find_by!(timing: :liked_event)
        user
      end
      let!(:not_allowed_user) { create(:user) }

      it '対象が正しいこと' do
        expect(User.allowing_liked_event_notification).to include(allowed_user)
        expect(User.allowing_liked_event_notification).not_to include(not_allowed_user)
      end
    end
  end

  describe 'メソッド' do
    describe 'attend' do
      let!(:user) { create(:user) }
      let!(:event) { create(:event) }
      it 'イベントへの参加処理が行われること' do
        expect do
          user.attend(event)
        end.to change { EventAttendance.count }.by(1)
      end
    end

    describe 'cancel_attend' do
      let!(:user) { create(:user) }
      let!(:event) { create(:event) }
      before do
        user.attend(event)
      end
      it 'イベントへのキャンセル処理が行われること' do
        expect do
          user.cancel_attend(event)
        end.to change { EventAttendance.count }.by(-1)
      end
    end

    describe 'can_attend?' do
      let(:other) { create :user }
      let(:woman) { create :user, :woman_user }
      let(:event) { create :event }
      let(:woman_only_event) { create :event, :woman_only_event }

      describe '女性限定event' do
        it '女性以外の場合falseが返ること' do
          expect(other.can_attend?(woman_only_event)).to be false
        end
        it '女性の場合trueが返ること' do
          expect(woman.can_attend?(woman_only_event)).to be true
        end
      end
      describe '女性限定ではないevent' do
        it '女性以外の場合trueが返ること' do
          expect(other.can_attend?(event)).to be true
        end
        it '女性の場合trueが返ること' do
          expect(woman.can_attend?(event)).to be true
        end
      end
      describe 'オーナーが作成したevent' do
        let(:owner) { create :user, :woman_user }
        let(:owner_event) { create :event, user: owner }
        it 'オーナーの場合falseが返ること' do
          expect(owner.can_attend?(owner_event)).to be false
        end
      end
    end
  end
end
