# Can work off of InsightsController

class IntegrationController < ApplicationController

  #protect_from_forgery with: :exception
  skip_before_action :ensure_authenticated_user

  def index
  end

end
