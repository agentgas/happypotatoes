class RatesController < ApplicationController
  # GET /api/rates
  def index
    if rate_params['time']
      begin
        datetime_param = DateTime.parse(rate_params['time'])
        datetime_start = datetime_param.beginning_of_day
        datetime_end = datetime_param.end_of_day

        @rates = Rate.where(time: datetime_start..datetime_end)
      rescue Date::Error
        render json: { error: "Invalid date format, usage: yearmonthday, ex: 20240105" }, status: :unprocessable_entity and return
      end
    else
      @rates = Rate.all.order(time: :asc)
    end

    render json: @rates, each_serializer: RatesSerializer
  end

  private

  def rate_params
    params.permit(:time)
  end
end
