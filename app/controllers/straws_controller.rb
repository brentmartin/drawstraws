class StrawsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def create
    straw_usernames = params[:text].split(' ')
    short_straw_username = straw_usernames.sample
    host_username = params[:user_name]

    straw_response = "@#{host_username} "
    straw_response += "created a straw poll for #{straw_usernames.to_sentence}.\n\n"
    straw_response += "*#{short_straw_username} has drawn the short straw*. Sucka!"

    slack_response = {
      "text": straw_response,
      "response_type": "in_channel"
    }

    render status: :ok, json: slack_response
  end
end
