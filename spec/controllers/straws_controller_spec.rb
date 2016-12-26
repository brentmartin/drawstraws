require 'rails_helper'

RSpec.describe StrawsController, :type => :controller do
  describe "POST /straws" do
    it "returns a single username from the list of usernames" do
      req = slack_request
      req[:text] = "@jess"

      post :create, req

      json_response = JSON.parse(response.body)
      expect(json_response["text"]).to eq "@jess"
    end

    it "chooses a user name from the list of user names" do
      req = slack_request
      req[:text] = "@elizabeth @brent"

      post :create, req

      json_response = JSON.parse(response.body)
      expect(json_response["text"]).to be_in(["@elizabeth", "@brent"])
    end
  end
end

def slack_request
  {
    "token"=>"5oqrzVhONee6k5RpfdH1XgWj", 
    "team_id"=>"T3JRVTPCJ", 
    "team_domain"=>"drawstraws", 
    "channel_id"=>"C3J530CNL", 
    "channel_name"=>"general", 
    "user_id"=>"U3J534MDW", 
    "user_name"=>"jess", 
    "command"=>"/straws", 
    "text"=>"some text", 
    "response_url"=>"https://hooks.slack.com/commands/T3JRVTPCJ/120179635216/xNvGpRgvr9aG6pna4mUAnu1U"
  }
end
