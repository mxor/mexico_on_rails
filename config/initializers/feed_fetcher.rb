if (not File.exist?('tmp/my_scheduler.lock'))
  FileUtils.touch('tmp/my_scheduler.lock')
  
  scheduler = Rufus::Scheduler.start_new
 
  scheduler.every "30m" do
    
    log_path = "#{RAILS_ROOT}/log/feeds_fetcher.log"
    FileUtils.touch(log_path) unless File.exist?(log_path)
    file = File.open(log_path, File::WRONLY | File::APPEND)
    logger = Logger.new(file)
    
    updated = []
    errors = 0

    FeedArticle.all.each do |feed|
      updated << feed.update_feed

      feed_could_be_read = (updated.last or feed.filled?)
      unless feed_could_be_read
        errors += 1
        logger.error "Error on: #{feed.feed_url} - #{Time.now}"
      end
    end
    
    logger.info "#{updated.select{|x|x}.size} of #{updated.size} Feeds updated (with #{errors} errors) - #{Time.now}"
    
    ActiveRecord::Base.verify_active_connections!
    
    logger.close
  end
 
  # scheduler.join
end
 
 
if Module.constants.include?('Mongrel') then
  class Mongrel::HttpServer
    alias :old_graceful_shutdown :graceful_shutdown
    def graceful_shutdown
      FileUtils.rm('tmp/my_scheduler.lock', :force => true)
      old_graceful_shutdown
    end
  end
end