desc "Update the feeds"
task :update_feeds => :environment do
  FeedUrl.all.each do |feed|
    FeedEntry.update_from_feed(feed.url)
  end
end
