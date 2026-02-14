class DatabaseBackupJob < ApplicationJob
  queue_as :low

  def perform
    require "open3"

    timestamp = Time.current.strftime("%Y%m%d_%H%M%S")
    backup_dir = Rails.root.join("tmp", "backups")
    FileUtils.mkdir_p(backup_dir)

    db_config = ActiveRecord::Base.connection_db_config.configuration_hash
    filename = "#{backup_dir}/cineverse_#{timestamp}.sql.gz"

    pg_dump_args = ["pg_dump"]
    pg_dump_args.push("-h", db_config[:host].to_s) if db_config[:host]
    pg_dump_args.push("-U", db_config[:username].to_s) if db_config[:username]
    pg_dump_args.push(db_config[:database].to_s)

    pg_dump_out, pg_dump_err, pg_dump_status = Open3.capture3(*pg_dump_args)

    unless pg_dump_status.success?
      Rails.logger.error "[DatabaseBackupJob] pg_dump failed: #{pg_dump_err}"
      return
    end

    File.open(filename, "wb") do |file|
      gz = Zlib::GzipWriter.new(file)
      gz.write(pg_dump_out)
      gz.close
    end

    # Clean up old backups (keep last 7 days)
    Dir.glob("#{backup_dir}/cineverse_*.sql.gz").sort[0...-7].each { |f| File.delete(f) }

    Rails.logger.info "[DatabaseBackupJob] Backup created: #{filename}"
  end
end
