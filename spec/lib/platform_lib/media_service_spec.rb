require "spec_helper"
require "platform_lib/web_helper"

describe "Media Service" do
  let(:data_service) do
    service = PlatformLib::DataService.new("user", "pass")
    service.stub(:sign_in)
    service.stub(:sign_out)
    service
  end

  subject { data_service.media_service }
  
  before do
    subject.stub(:sign_in)
    subject.stub(:sign_out)
  end

  it { should respond_to(:get_media_items) }
  it { should respond_to(:update_media_items) }
  
  describe "#get_media_items" do
    before do
      json_response = <<HEREDOC
      {
        "$xmlns": "http://somedomain.com/",
        "entries": [
          {
            "id": "http://domain.com/id",
            "title": "Item 1"
          },
          {
            "id": "http://domain.com/id",
            "title": "Item 2"
          }
        ]
      }
HEREDOC

      PlatformLib::WebHelper.stub(:get).and_return(json_response)
    end

    it "returns media items" do
      expect(subject.get_media_items).to_not be_nil
    end

    it "executes block for each item" do
      titles = []
      subject.get_media_items do |item|
        titles << item.title
      end

      expect(titles.size).to eq(2)
    end

  end
end