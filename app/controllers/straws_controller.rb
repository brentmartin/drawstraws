class StrawsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def create
    # basic parsing
    straw_usernames = params[:text].split(' ')
    host_username = params[:user_name]

    # advanced parsing
    straw_task_description = params[:text].scan(/\"(.+)\"/).flatten.join
    straw_selected_users = params[:text].scan(/@[a-zA-Z0-9_\-\.]{1,21}\b/)

    # selection logic
    short_straw_username = straw_selected_users.sample
    straw_list = straw_selected_users.join("\n")

    # message creation
    straw_host_message = "A straw drawing was created by @#{host_username} "
    straw_selection_message = "*<#{short_straw_username}> has drawn the short straw!*"

    slack_response = {
      "attachments": [
          {
              "fallback": "#{straw_host_message}. Let's draw straws for it! #{straw_task_description}. Drawing from: #{straw_list}",
              "pretext": straw_host_message,
              "color": "#70CADB",
              "title": "Let's draw straws for it!",
              "title_link": "http://letsdrawstraws.com",
              "text": straw_task_description,
              "fields": [
                  {
                      "title": "drawing from:",
                      "value": straw_list,
                      "short": false
                  }
              ],
              "mrkdwn_in": ["text"]
          },
          {
              "fallback": "#{short_straw_username} has drawn the short straw.",
              "color": "#FFA500",
              "text": straw_selection_message,
              "mrkdwn_in": ["text"]
          },
          {
              "fallback": "Thanks for drawing! Questions? Visit our help center using the following url: http://letsdrawstraws.com DrawStraws.",
              "color": "#70CADB",
              "text": "_Thanks for drawing! Questions? Visit our <http://letsdrawstraws.com|help center>._",
              "footer": "DrawStraws",
              "mrkdwn_in": ["text"]
          }
      ],
      "response_type": "in_channel"
    }

    render status: :ok, json: slack_response
  end
end
