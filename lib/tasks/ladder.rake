require 'ladder'

namespace :ladder do
  desc 'Display whole ladder history in accessible manner'
  task :history => :environment do
    games = Ladder::History.retrieve
    games.each {|g| puts g}
  end
end
