require 'open-uri'
require 'date'

url = "http://localhost:3000/administrator/assignments/9?status=ece"

start = Time.new
f = open(url).read
stop = Time.new

puts "Time elapsed: #{stop - start} seconds"

