# frozen_string_literal: true

class EventAttendance < ApplicationRecord
  include Notifiable
  belongs_to :user
  belongs_to :event

  validates :user_id, uniqueness: { scope: :event_id }
  validate :validate_only_woman

  private

  def validate_only_woman
    errors.add('女性限定イベントに申し込みできません') unless event.available?(user)
  end
end
