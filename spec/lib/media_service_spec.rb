require "spec_helper"

describe "Media Service" do
  subject { PlatformLib::MediaService.new("user", "pass") }
  before do
    subject.stub(:with_authentication_token) do |&block|
      block.call "some_auth_token"
    end
  end

  it { should respond_to(:query) }
  it { should respond_to(:query_uri) }

  # seems like protected attribtues not available 
  # before 2.0.0
  if RUBY_VERSION != "1.9.3"
    it { should_not respond_to(:username) }
    it { should_not respond_to(:password)}
  end

  describe "#query" do
    let(:params) do 
      { 
        fields: "id,guid,title"
      } 
    end

    before do
      subject.stub(:execute_query).and_return([
        double("mock1"),
        double("mock2")
      ])
    end

    context "when called without a block" do
      let(:result) { subject.query(params) }

      it "returns the media items" do
        expect(result).to_not be_nil
        expect(result.size).to eq(2)
      end
    end

    context "when called with a block" do
      it "executes the block once per item" do
        item_count = 0
        subject.query(params) do |item|
          item_count += 1
        end

        expect(item_count).to eq(2)
      end
    end
  end

  describe "#query_uri" do
    let(:params) do
      { 
        fields: "id,guid,title",
        pretty: true,
        form: "cjson",
        schema: "1.6.0",
        byCustomValue: "{someFlag}{true}"
      }
    end

    let(:uri) { subject.query_uri(params) }

    it "sets the correct host and port" do
      uri.host.should eq("data.media.theplatform.com")
      uri.port.should eq(80)
    end

    it "handles boolean params" do
      uri.to_s.should include("pretty=true")
    end

    it "handles string parameters" do
      uri.to_s.should include("schema=1.6.0")
    end
  end
end

