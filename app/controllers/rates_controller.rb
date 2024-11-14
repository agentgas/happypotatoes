class RatesController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_record

  # GET /api/rates
  def index
    rates = Rate.all.order(time: :asc)

    render json: rates, each_serializer: RatesSerializer
  end

  private
  def handle_invalid_record(e)
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end
end
