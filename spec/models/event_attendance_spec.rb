# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventAttendance, type: :model do
  describe 'validation' do
    let(:other) { create :user }
    let(:woman) { create :user, :woman_user }
    let(:woman_only_event) { create :event, :woman_only_event }
    it 'イベントに申し込みできること' do
      woman_attendance = build(:event_attendance, user: woman, event: woman_only_event)
      expect(woman_attendance).to be_valid
      expect(woman_attendance.errors).to be_empty
    end

    it 'イベントに申し込みできないこと' do
      other_attendance = build(:event_attendance, user: other, event: woman_only_event)
      expect(other_attendance).to be_invalid
      expect(other_attendance.errors).to include 'イベントに申し込みできません'
    end
  end
end
