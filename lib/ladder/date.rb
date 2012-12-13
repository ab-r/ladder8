require 'cgi'
require 'date'

module Ladder
  class Date
    LONG  = '%Y-%m-%d %H:%M:%S'
    SHORT = '%Y-%m-%d'

    def initialize date
      @date = date
    end

    def to_param
      return nil unless valid?
      @date.strftime LONG
    end

    def to_s
      @date.strftime SHORT
    end

    def to_url
      return options[:base_url] unless valid?

      date  = CGI.escape to_param
      order = CGI.escape '<='

      options[:base_url] + "?reportdate=#{date}&reporteddirection=#{order}"
    end

    def valid?
      @date > options[:boundary]
    end

    private

    def options
      {
        :base_url => 'http://wesnoth.gamingladder.info/gamehistory.php',
        :boundary => DateTime.civil(2009, 9, 20)
      }
    end

    class << self
      def current
        new DateTime.now
      end

      def parse string
        new DateTime.strptime string, LONG
      end
    end
  end
end
