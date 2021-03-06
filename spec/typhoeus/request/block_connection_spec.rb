require 'spec_helper'

describe Typhoeus::Request::BlockConnection do
  let(:url) { "localhost:3001" }
  let(:request) { Typhoeus::Request.new(url, {:method => :get}) }

  describe "queue" do
    context "when block_connection activated" do
      before { Typhoeus::Config.block_connection = true }
      after { Typhoeus::Config.block_connection = false }

      it "raises" do
        expect{request.run}.to raise_error(Typhoeus::Errors::NoStub)
      end
    end
  end
end
