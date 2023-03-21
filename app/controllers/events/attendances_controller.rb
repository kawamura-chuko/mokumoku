# frozen_string_literal: true

class Events::AttendancesController < ApplicationController
  before_action :set_event, only: %i[create destroy]

  def create
    if @event.available?(current_user)
      event_attendance = current_user.attend(@event)
      (@event.attendees - [current_user] + [@event.user]).uniq.each do |user|
        NotificationFacade.attended_to_event(event_attendance, user)
      end
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
