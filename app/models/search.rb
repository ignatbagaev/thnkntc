class Search
  OBJECTS = %w(everywhere answers questions comments)

  def self.find(query, object)
    return [] if Search.invalid?(query, object)
    return ThinkingSphinx.search("*#{query}*") if object == 'everywhere'

    object.classify.constantize.search("*#{query}*")
  end

  private_class_method

  def self.invalid?(query, object)
    true if !query || query && query.strip.empty? || !Search::OBJECTS.include?(object)
  end
end

