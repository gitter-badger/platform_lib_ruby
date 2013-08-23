#
# This script is for our global tv account. Since the migration from feeds2 
# to feeds3 we began using the guid field to reference the old id's in 
# MDialog. 
#
# Now that the migration is done, we need new items to copy their id value to
# the guid field so the app continues to work correctly.
#
# This is a temporary measure and will be removed at a later dat
#
#
# To run use tp_lib, like this:
#
#    $ tp_lib username password
#
$: << File.expand_path("../../../lib", __FILE__)
require "platform_lib"
require 'json'

user = ARGV[0]
pass = ARGV[1]

service = PlatformLib::DataService.new(user, pass)

params = {
  fields: "id,guid",
  schema: "1.6.0",
  form: "cjson",
  byCustomValue: "{mDialogIngestSuccess}{true}",
  range: "1-2",
  sort: "added|desc",
  account: "Shaw - GlobalTV"
}

update_params = {
  schema: "1.2",
  account: "Shaw - GlobalTV"
}

items = []

begin
  service.media_service.get_media_items(params) do |item|
    # these are the old items
    #next if item.guid =~ /\A\d+\z/

    # if item.guid != item.id.split('/').last
    #   item.guid = item.id.split('/').last.to_s
    #   items << item
    # end
    items << item
  end

  # update the items
  items.each { |item| item.guid = item.id.split('/').last }

  if items.empty?
    puts "All items are up to date."
  else
    service.media_service.update_media_items(items, update_params)
    puts "Updated #{items.size} items."
  end
ensure
  service.sign_out
end