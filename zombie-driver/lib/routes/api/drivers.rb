get '/drivers/:id' do
  content_type :json

  driver_id = params[:id]
  distance_service = Services::Distance.new
  result = distance_service.call(driver_id)
  return {}.to_json if result.failure?
  zombie = result.value < 500
  { id: driver_id, zombie: zombie }.to_json
end
