require 'nokogiri'
require 'open-uri'

module Ladder
  class History
    def retrieve from = nil
      from ||= Date.current
      init   = process from

      @current = @games = init

      while not @current.empty?
        break unless @current.oldest_date.valid?

        @current = process @current.oldest_date
        @games  += @current
      end

      @games.uniq.reverse
    end

    private

    def convert object
      object.to_url or object
    end

    def process date
      unrevoked_games date
    end

    def revoked_games date
      games(date).reject {|g| not g.revoked?}
    end

    def unrevoked_games date
      games(date).reject {|g| g.revoked?}
    end

    def games date
      data = Nokogiri.HTML(open convert date).games
      data.map {|g| Game.new *g}
    end

    class << self
      def retrieve from = nil
        new.retrieve from
      end
    end
  end
end
