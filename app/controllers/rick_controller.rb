# Can work off of InsightsController

class RickController < ActionController::Base

  protect_from_forgery with: :exception

  def index  render partial: 'index'

    render partial: 'index'

  end

end
