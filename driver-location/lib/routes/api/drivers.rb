get '/drivers/:id/locations' do
  content_type :json

  service = Services::Redis::CoordinatesQuery.new
  result = service.call(params[:id])
  return [500, []] if result.failure?
  [200, result.value.to_json]
end
