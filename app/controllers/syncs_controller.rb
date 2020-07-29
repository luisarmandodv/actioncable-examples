class SyncsController < ApplicationController
  def index
    @syncs = @current_user.syncs
  end

  def create
    @sync = Sync.create! content: params[:sync][:content], user: @current_user
  end

end
