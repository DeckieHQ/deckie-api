class ConfirmFlexibleEvents < ApplicationJob
  queue_as :scheduler

  def perform
    Event.confirmables(percentage: 10).each do |event|
      ConfirmTimeSlot.new(event.host, event.optimum_time_slot).call
    end
  end
end
