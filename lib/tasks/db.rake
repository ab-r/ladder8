namespace :db do
  desc 'Recalculate player/side ratings'
  task :recalculate => :environment do
    Player.find_in_batches do |players|
      players.each {|p| p.deviation = p.deviation_initial ; p.mean = p.mean_initial ; p.save!}
    end

    Game.find_in_batches do |games|
      games.each {|g| g.update_ratings if g.confirmed_cache}
    end
  end
end
