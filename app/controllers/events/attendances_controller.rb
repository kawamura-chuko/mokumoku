# frozen_string_literal: true

class Events::AttendancesController < ApplicationController
  before_action :set_event, only: %i[create destroy]

  def create
    event_attendance = current_user.attend(@event)
    if event_attendance.present? && event_attendance.id
      @event.notify_attendees(event_attendance, current_user)
      redirect_back(fallback_location: root_path, success: '参加の申込をしました')
    else
      render 'events/show'
    end
  end

  def destroy
    current_user.cancel_attend(@event)
    redirect_back(fallback_location: root_path, success: '申込をキャンセルしました')
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end
end
