get '/drivers/:id/locations' do
  content_type :json
  key = "drivers:coordinates:#{params[:id]}"
  now = Time.now
  check_time = now - ( 5 * 60 )
  result = REDIS.zrangebyscore(key, check_time.to_i, now.to_i)
  result.map { |r| JSON.parse(r) }.to_json
end
