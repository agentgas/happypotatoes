require 'rails_helper'

RSpec.describe "Rates", type: :request do
  describe 'GET /api/rates' do
    context 'when time param is NOT provided' do
      it 'returns a bad_request response' do
        get '/api/rates'
        
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when time param is NOT a valid date' do
      let(:time_param) { 'TestyPotato' }

      it 'returns an unprocessable_content response' do
        get '/api/rates', params: { time: time_param }
        
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context 'when time param is valid' do
      let(:time_param) { '20240105' }

      it 'returns a successful response' do
        get '/api/rates', params: { time: time_param }
        
        expect(response).to have_http_status(:success)
      end

      context 'when there is no rates on this date' do
        it 'returns an empty array' do
          get '/api/rates', params: { time: time_param }

          expect(JSON.parse(response.body)).to be_empty
        end
      end

      context 'when there is some rates' do
        let!(:rate1) { Rate.create(time: DateTime.new(2024, 1, 5, 0, 0, 0), value: 11.04) }
        let!(:rate2) { Rate.create(time: DateTime.new(2024, 1, 5, 0, 0, 0), value: 100.04) }
        let!(:rate3) { Rate.create(time: DateTime.new(2024, 1, 25, 0, 0, 0), value: 117.12) }
        let!(:rate4) { Rate.create(time: DateTime.new(2024, 2, 5, 0, 0, 0), value: 42.42) }

        it 'returns only date related rates' do
          get '/api/rates', params: { time: time_param }

          json_reponse = JSON.parse(response.body)

          expect(json_reponse.length).to eq(2)
          expect(json_reponse[0]['value']).to eq(11.04)
          expect(json_reponse[1]['value']).to eq(100.04)
        end
      end
    end
  end

  describe 'GET /api/profitmax' do
    context 'when time param is NOT provided' do
      it 'returns a bad request response' do
        get '/api/profitmax'
        
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when time param is NOT a valid date' do
      let(:time_param) { 'TestyPotato' }

      it 'returns a unprocessable_content response' do
        get '/api/profitmax', params: { time: time_param }
        
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context 'when time param is valid' do
      context 'when there is no rates on this date' do
        let(:time_param) { '20240105' }

        it 'returns a not_found response' do
          get '/api/profitmax', params: { time: time_param }
          
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'when there is some rates on this date' do
        let!(:rate1) { Rate.create(time: DateTime.new(2024, 1, 5, 0, 0, 0), value: 11.04) }
        let!(:rate2) { Rate.create(time: DateTime.new(2024, 1, 5, 0, 0, 0), value: 100.04) }
        let!(:rate3) { Rate.create(time: DateTime.new(2024, 1, 5, 0, 0, 0), value: 117.12) }
        let(:time_param) { '20240105' }

        it 'returns a successful response' do
          get '/api/profitmax', params: { time: time_param }
          
          expect(response).to have_http_status(:success)
        end

        it 'returns correct data' do
          get '/api/profitmax', params: { time: time_param }

          expect(response.body).to include("10608")
        end
      end
    end
  end
end
