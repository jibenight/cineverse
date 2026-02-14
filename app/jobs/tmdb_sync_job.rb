class TmdbSyncJob < ApplicationJob
  queue_as :default

  def perform
    TmdbSyncService.new.sync_all
    Rails.logger.info "[TmdbSyncJob] Sync completed at #{Time.current}"
  end
end
