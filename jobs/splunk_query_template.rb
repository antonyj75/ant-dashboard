require 'yaml'
require 'splunk-sdk-ruby'

# TODO: Update the splunk_connection.yml file to contain your splunk server connection information
connect_config = YAML.load_file('config/splunk_connection.yml')

# TODO: Your query here
query = 'search ...'

splunk = Splunk::connect(connect_config)

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '30m', :first_in => 0 do |job|

  stream = splunk.create_oneshot(query)

  results = Splunk::ResultsReader.new(stream)

  results.each do |result|
    # TODO: Your query result record processing here
  end

  send_event('widgetId', { })
end
