require "spec_helper"

describe "Data Service" do
  subject { PlatformLib::DataService.new("user", "password") }
  
  before do
    subject.stub(:sign_in)
    subject.stub(:sign_out)
  end

  after { subject.sign_out }

  describe "#_service" do

    it "creates an instance" do
      expect(subject.media_service).to_not be_nil
    end
  end
end