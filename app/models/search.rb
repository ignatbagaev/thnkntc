class Search
  def self.find(query)
    if query && !query.strip.empty?
      Question.search("*#{query}*")
    else
      []
    end
  end
end
