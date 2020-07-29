#*DTA Here!
class Sync < ActiveRecord::Base
  belongs_to :user

  after_commit { SyncRelayJob.perform_later(self) }
end
