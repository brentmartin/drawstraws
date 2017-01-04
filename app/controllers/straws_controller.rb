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
    straw_list = ""
    straw_selected_users.each { |username| straw_list += "#{username}\n" }

# message creation
    straw_host_message = "A straw drawing was created by @#{host_username} "
    straw_selection_message = "*<#{short_straw_username}> has drawn the short straw!*"

    slack_response = {
      "attachments": [
          {
              "fallback": "Required plain-text summary of the attachment.",
              "pretext": straw_host_message,
              "color": "#70CADB",
              "title": "Let's draw straws for it!",
              "title_link": "https://trello.com/b/4TTrKn3s/draw-straws",
              "text": "We need fresh coffee made! Short straw brews the next batch!",
              "fields": [
                  {
                      "title": "drawing from:",
                      "value": straw_list,
                      "short": false
                  }
              ]
          },
          {
              "fallback": "Required plain-text summary of the attachment.",
              "color": "#FFA500",
              "text": straw_selection_message,
              "mrkdwn_in": ["text"]
          },
          {
              "fallback": "Required plain-text summary of the attachment.",
              "color": "#70CADB",
              "text": "_Thanks for drawing! Questions? Visit our <http://letsdrawstraws.com|help center>._",
              "image_url": "http://my-website.com/path/to/image.jpg",
              "thumb_url": "http://example.com/path/to/thumb.png",
              "footer": "DrawStraws",
              "footer_icon": "https://platform.slack-edge.com/img/default_application_icon.png",
              "ts": 123456789,
              "mrkdwn_in": ["text"]
          }
      ],
      "response_type": "in_channel"
    }

    render status: :ok, json: slack_response
  end
end
