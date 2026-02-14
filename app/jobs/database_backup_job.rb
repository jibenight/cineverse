class DatabaseBackupJob < ApplicationJob
  queue_as :low

  def perform
    timestamp = Time.current.strftime("%Y%m%d_%H%M%S")
    backup_dir = Rails.root.join("tmp", "backups")
    FileUtils.mkdir_p(backup_dir)

    db_config = ActiveRecord::Base.connection_db_config.configuration_hash
    filename = "#{backup_dir}/cineverse_#{timestamp}.sql.gz"

    cmd = "pg_dump"
    cmd += " -h #{db_config[:host]}" if db_config[:host]
    cmd += " -U #{db_config[:username]}" if db_config[:username]
    cmd += " #{db_config[:database]}"
    cmd += " | gzip > #{filename}"

    system(cmd)

    # Clean up old backups (keep last 7 days)
    Dir.glob("#{backup_dir}/cineverse_*.sql.gz").sort[0...-7].each { |f| File.delete(f) }

    Rails.logger.info "[DatabaseBackupJob] Backup created: #{filename}"
  end
end
