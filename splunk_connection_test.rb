require 'splunk-sdk-ruby'

service = Splunk::Service.new(:host => "localhost",
                              :port => 8089,
                              :username => "admin",
                              :password => "changeme").login()

service.users.each do |user|
  puts user.name
end
