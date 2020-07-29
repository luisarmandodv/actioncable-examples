#*DTA Here!
class SyncRelayJob < ApplicationJob
  def perform(sync) #*DTA should be sync, and other stuff should be changed too
    ActionCable.server.broadcast "integration_name:#{sync.user_id.to_i}:sync",
      sync: SyncsController.render(partial: 'syncs/sync', locals: { sync: sync })
    sleep 3
    ActionCable.server.broadcast "integration_name:#{sync.user_id.to_i}:sync",
      sync: SyncsController.render(partial: 'syncs/sync', locals: { sync: sync })
  end
end