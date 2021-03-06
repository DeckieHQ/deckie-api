class FlexibleEventReminder
  attr_reader :user, :event

  delegate :time_slots, to: :event

  def initialize(user, event)
    @user  = user
    @event = event
  end

  def subject
    I18n.t('mailer.flexible_event_reminder.subject', title: event.title)
  end

  def details
    I18n.t('mailer.flexible_event_reminder.subject', title: "<b>#{event.title}</b>")
  end

  def event_url
    UrlHelpers.front_for("event/#{event.id}")
  end
end
