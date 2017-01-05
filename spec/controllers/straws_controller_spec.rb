require 'rails_helper'

RSpec.describe StrawsController, :type => :controller do
  describe "POST /straws" do
    it "returns a single username from the list of usernames" do
      req = slack_request
      req[:text] = "@jess"

      post :create, req

      json_response = JSON.parse(response.body)
      expect(json_response["attachments"][0]["fields"][0]["value"]).to include("@jess")
    end

    it "chooses a short straw from the list of user names" do
      req = slack_request
      req[:text] = "@elizabeth @brent"

      post :create, req

      straws_response = JSON.parse(response.body)["attachments"][1]["text"]

      expect(
        straws_response.include?("@elizabeth") || straws_response.include?("@brent")
      ).to be true
    end

    it "specifies who started the straw poll" do
      req = slack_request
      req[:text] = "@elizabeth @brent"
      req[:user_name] = "jess"

      post :create, req

      json_response = JSON.parse(response.body)
      expect(json_response["attachments"][0]["pretext"]).to include("@jess")
    end

    it "lists all the usernames involved in the straw poll" do
      req = slack_request
      req[:text] = "@elizabeth @brent"

      post :create, req

      json_response = JSON.parse(response.body)
      expect(json_response["attachments"][0]["fields"][0]["value"]).to include("@elizabeth\n@brent")
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
