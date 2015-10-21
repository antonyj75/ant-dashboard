require 'yaml'
require 'splunk-sdk-ruby'

connect_config = YAML.load_file('config/splunk_connection.yml')

query = 'search sourcetype=access_* status=200 action=purchase | top categoryId'

splunk = Splunk::connect(connect_config)

header = [{"cols" => [{"value" => "Category"},
                       {"value" => "No. of Purchases"},
                       {"value" => "Purchase Percent"}
                     ]}]

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '30m', :first_in => 0 do |job|

  stream = splunk.create_oneshot(query)

  results = Splunk::ResultsReader.new(stream)

  rows = []

  results.each do |result|
    row = [{"value" => result['categoryId']}, 
           {"value" => result['count']},
           {"value" => result['percent']}
          ]
      rows << { "cols" => row }
  end

  send_event('top_categories_table', { hrows: header, rows: rows })
end

