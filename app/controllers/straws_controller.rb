class StrawsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def create
    straw_usernames = params[:text].split(' ')
    short_straw_username = straw_usernames.sample
    host_username = params[:user_name]

    straw_host_message = "A straw drawing was created by @#{host_username} "
    straw_participants = "created a straw drawing for #{straw_usernames.to_sentence}."
    straw_selection_message = "#{short_straw_username} has drawn the short straw!"

    slack_response = {
      "response_type": "in_channel"
    }

    render status: :ok, json: slack_response
  end
end
