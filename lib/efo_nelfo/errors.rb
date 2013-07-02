module EfoNelfo
  InvalidPostType       = Class.new(StandardError)
  UnsupportedPostType   = Class.new(StandardError)
  DuplicateProperty     = Class.new(StandardError)
  UnknownPropertyOption = Class.new(StandardError)
  InvalidPropertyType   = Class.new(StandardError)
end
