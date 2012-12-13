class Array
  def oldest_date
    last.date rescue nil
  end
end

module Nokogiri::XML
  class Node
    def games
      row_path = '#games tbody tr'

      search(row_path).map do |row|
        contents = row.children.collect &:content
        contents[0...3]
      end
    end
  end
end
