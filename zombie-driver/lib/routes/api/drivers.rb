get '/drivers/:id' do
  content_type :json

  driver_id = params[:id]
  response = Services::HttpRequest.get("http://localhost:4002/drivers/#{driver_id}/locations")
  body = response.body
  result = JSON.parse(body)
  first_coordinates = [result[0]['longitude'].to_f,  result[0]['latitude'].to_f]
  last_coordinates = [result[-1]['longitude'].to_f,  result[-1]['latitude'].to_f]
  distance = Services::DistanceCalculator.call(first_coordinates, last_coordinates)
  zombie = distance < 500
  { id: params[:id], zombie: zombie }.to_json
end
