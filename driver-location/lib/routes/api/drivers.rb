get '/drivers/:id/locations' do
  content_type :json

  service = Services::Redis::CoordinatesQuery.new
  locations = service.call(params[:id])
  locations.to_json
end
