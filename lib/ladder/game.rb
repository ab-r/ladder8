require 'ansicolor'

module Ladder
  class Game
    attr_reader :date, :winner, :loser

    def eql? object
      return false unless object.is_a? Game

      object.date   == @date   and \
      object.winner == @winner and \
      object.loser  == @loser
    end

    def initialize date, winner, loser
      @date   = Date.parse date
      @winner = remove_marker winner
      @loser  = remove_marker loser

      set_revoked_status winner, loser
    end

    def revoked?
      @revoked
    end

    def to_hash
      {
        :date    => @date,
        :winner  => @winner,
        :loser   => @loser,
        :revoked => @revoked
      }
    end

    def to_s
      "#{@date} #{ac.green @winner} #{ac.red @loser}"
    end

    def to_yaml
      to_hash.to_yaml
    end

    private

    def options
      {:revoke_marker => '*'}
    end

    def remove_marker name
      name.gsub options[:revoke_marker], ''
    end

    def set_revoked_status *data
      @revoked = "#{data}".include? options[:revoke_marker]
    end
  end
end
