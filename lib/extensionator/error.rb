module Extensionator
  class Error < StandardError

    ArgumentError = Class.new(self)
    KeyError = Class.new(self)
    ValidationError = Class.new(self)
  end
end

