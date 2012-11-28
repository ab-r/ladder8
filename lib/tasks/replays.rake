require 'nokogiri'
require 'open-uri'
require 'replay'
require 'term/ansicolor'

namespace :replays do
  desc 'Display RBY games'
  task :display => :environment do
    games = crawl_archive 'RBY_Side'

    for game in games do
      begin
        print_array ac.green(game), *Replay.load(game).players
      rescue => e
        print_array ac.red(game), e.to_s
      end
    end
  end

  private

  def crawl_archive name
    games = []

    host    = 'http://replays.wesnoth.org'
    version = Ladder8::Application.config.wesnoth_version

    link_sel = 'td:nth-child(2) > a'
    side_sel = 'td:nth-child(5)'

    0.upto 6 do |ago|
      dir = ago.days.ago.strftime '%Y%m%d'
      doc = Nokogiri.HTML open("#{host}/#{version}/#{dir}") rescue break

      doc.css('tr').each do |row|
        link  = first_match row, link_sel
        sides = first_match row, side_sel

        if link and link.match(/gz$/) and sides.match(/#{name}/)
          games << "#{host}/#{version}/#{dir}/#{link}"
        end
      end
    end

    games
  end

  def ac
    Term::ANSIColor
  end

  def first_match data, sel
    data.css(sel).first.text rescue nil
  end

  def print_array *items
    puts items.join ' '
  end
end
