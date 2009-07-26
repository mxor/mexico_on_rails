desc "Update the feeds"
task :update_feeds => :environment do
  updated = []
  errors = 0

  FeedArticle.all.each do |feed|
    updated << feed.update_feed
  end
end
