class RatesController < ApplicationController
  
  # GET /api/rates
  def index
    if rate_params['time']
      datetime_start, datetime_end = parse_time_param(rate_params['time'])

      if datetime_start.nil? || datetime_end.nil?
        return handle_time_parsing_error
      end

      @rates = Rate.where(time: datetime_start..datetime_end)
    else
      return handle_no_time_param
    end

    render json: @rates, each_serializer: RatesSerializer
  end

  # GET /api/profitmax
  def profit
    if rate_params['time']
        datetime_start, datetime_end = parse_time_param(rate_params['time'])

        if datetime_start.nil? || datetime_end.nil?
          return handle_time_parsing_error
        end

        # fetch highest and lowest values
        rates = Rate.where(time: datetime_start..datetime_end).select('MAX(value) AS max_value, MIN(value) AS min_value').first
        highest_value_rate = rates&.max_value
        lowest_value_rate = rates&.min_value

        if highest_value_rate.nil? || lowest_value_rate.nil?
          return render json: { error: "No rates on this date" }, status: :not_found
        end

        highest_profit = ((highest_value_rate - lowest_value_rate) * 100).to_i
    else
      return handle_no_time_param
    end

    render json: {highest_profit: "#{highest_profit}€"}
  end

  private

  def rate_params
    params.permit(:time)
  end

  def parse_time_param(time)
    begin
      datetime_param = DateTime.parse(time)

      [datetime_param.beginning_of_day, datetime_param.end_of_day]
    rescue Date::Error
      nil
    end
  end

  def handle_time_parsing_error
    render json: { error: "Invalid date format, usage: yearMonthDay, ex: 20240105" }, status: :unprocessable_entity
  end

  def handle_no_time_param
    render json: {error: "Need time param. format: yearMonthDay, ex: 20240104"}, status: :not_found
  end
end
