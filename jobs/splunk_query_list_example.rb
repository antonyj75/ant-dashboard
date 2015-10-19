require 'yaml'
require 'splunk-sdk-ruby'

connect_config = YAML.load_file('config/splunk_connection.yml')

query = 'search sourcetype=access_* status=200 action=purchase | top categoryId | eval percent=round(percent, 2)'

splunk = Splunk::connect(connect_config)

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '30m', :first_in => 0 do |job|

  stream = splunk.create_oneshot(query)

  results = Splunk::ResultsReader.new(stream)

  list_items = Hash.new({ value: 0 })

  results.each do |result|
    list_items[result['categoryId']] = { label: result['categoryId'], value: result['percent']+'%' }
  end

  send_event('categories_by_salepercent', { items: list_items.values })
end
