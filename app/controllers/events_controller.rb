class EventsController < ApplicationController
  load_and_authorize_resource

  def rsvp
    if request.get?
      @rsvp = Rsvp.new
    else
      if params[:commit] == 'Accept' && rsvp_params[:email].presence.nil? && rsvp_params[:phone].presence.nil?
        flash[:error] = 'Please provide either an email or a phone number.'
      else
        parent = Rsvp.create(
          event: @event,
          name: rsvp_params[:names].shift,
          email: rsvp_params[:email].presence,
          phone: rsvp_params[:phone].presence,
          notes: rsvp_params[:notes].presence,
          status: params[:commit] == 'Accept' ? 'accepted' : 'declined'
        )

        if parent.persisted?
          rsvp_params[:names].each do |name|
            next if name.blank?

            Rsvp.create(
              event: @event,
              name: name,
              email: rsvp_params[:email].presence,
              phone: rsvp_params[:phone].presence,
              notes: rsvp_params[:notes].presence,
              status: params[:commit] == 'Accept' ? 'accepted' : 'declined',
              parent: parent
            )
          end
        end
      end

      redirect_to @event
    end
  end

  def rsvps
    @rsvps = @event.rsvps.where(parent_id: nil).includes(:children).order(:created_at)
  end

  def show
    @rsvp = Rsvp.new
  end

  def new
    @event = Event.new
  end

  def edit; end

  def create
    @event = Event.new(event_params)
    @event.user = current_user

    if @event.save
      redirect_to @event, notice: 'Event was successfully created!'
    else
      render :new
    end
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @event.destroy
    respond_to do |format|
      flash[:notice] = 'Event successfully deleted!'
      format.html { redirect_to events_url }
      format.json { render json: { message: 'Blog deleted!' } }
    end
  end

  def publish
    if @event.publish!
      redirect_to @event, notice: 'Event published!'
    else
      render :edit, alert: 'Error publishing event!'
    end
  end

  def unpublish
    @event.unpublish!
    redirect_to @event, alert: 'Event unpublished!'
  end

  private

  def event_params
    params.require(:event).permit(:title, :body)
  end

  def rsvp_params
    params.require(:rsvp).permit!
  end
end
