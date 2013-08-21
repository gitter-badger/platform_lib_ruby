$: << File.expand_path("../../lib", __FILE__)
require "platform_lib"
require 'json'

user = ARGV[0]
pass = ARGV[1]

service = PlatformLib::MediaService.new(user, pass)
params = {
  fields: "id,guid",
  schema: "1.6.0",
  form: "cjson",
  byCustomValue: "{mDialogIngestSuccess}{true}",
  range: "1-100",
  sort: "added|desc",
  account: "Shaw - GlobalTV"
}

items = []

service.query(params) do |item|
  # these are the old items
  next if item["guid"] =~ /\A\d+\z/

  if item["guid"] != item["id"].split('/').last
    item["guid"] = item["id"].split('/').last.to_s
    items << item
  end
end

if items.empty?
  puts "All items are up to date."
else
  payload = {
    entries: items
  }

  puts "We need to update the following items..."
  puts JSON.pretty_generate(payload)
end