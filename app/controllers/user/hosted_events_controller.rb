class User::HostedEventsController < ApplicationController

  delegate :hosted_events, to: :current_user

  before_action :authenticate!

  before_action :verified!, only: :create

  before_action :event_closed?, only: [:update, :destroy]

  before_action -> { check_parameters_for :events }, only: [:create, :update]

  def index
    return render_pagination_errors unless current_page.valid?

    events = hosted_events.filter(filtering_params).paginate(current_page.params)

    render json: events
  end

  def show
    render json: event
  end

  def create
    event = Event.new(event_params)

    return render_validation_errors(event) unless hosted_events << event

    render json: event, status: :created
  end

  def update
    return render_validation_errors(event) unless event.update(event_params)

    render json: event
  end

  def destroy
    event.destroy

    head :no_content
  end

  protected

  def event
    @event ||= hosted_events.find(params[:id])
  end

  def event_params
    resource_attributes.permit(
     :title, :category, :ambiance, :level, :capacity, :invite_only, :description,
     :begin_at, :end_at, :street, :postcode, :city, :state, :country
    )
  end

  def filtering_params
    params.fetch(:filters, {}).slice(:opened)
  end

  def event_closed?
    render_validation_errors(event) if event.closed?
  end
end