# frozen_string_literal: true

class EventAttendance < ApplicationRecord
  include Notifiable
  belongs_to :user
  belongs_to :event

  validates :user_id, uniqueness: { scope: :event_id }
  validate :validate_can_attend

  private

  def validate_can_attend
    errors.add('イベントに申し込みできません') unless user.can_attend?(event)
  end
end
