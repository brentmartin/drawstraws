class StrawsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def create
    short_straw_username = params[:text].split(' ').sample

    slack_response = {
      "text": short_straw_username,
      "response_type": "in_channel"
    }

    render status: :ok, json: slack_response
  end
end
