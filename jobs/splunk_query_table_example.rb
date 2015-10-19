require 'yaml'
require 'splunk-sdk-ruby'

connect_config = YAML.load_file('config/splunk_connection.yml')

query = 'search sourcetype=access_* status=200 action=purchase | top categoryId'

splunk = Splunk::connect(connect_config)

header = [{"cols" => [{"value" => "Game Category"},
                       {"value" => "Number of Purchases", "style" => "text-align:center"},
                       {"value" => "Purchase Percentage", "style" => "text-align:center"}
                     ]}]

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '30m', :first_in => 0 do |job|

  stream = splunk.create_oneshot(query)

  results = Splunk::ResultsReader.new(stream)

  rows = []

  results.each do |result|
    row = [{"value" => result['categoryId']}, 
           {"value" => result['count'], "style" => "text-align:center"},
           {"value" => result['percent'], "style" => "text-align:center"}
          ]
      rows << { "cols" => row }
  end

  send_event('top_categories_table', { hrows: header, rows: rows })
end

