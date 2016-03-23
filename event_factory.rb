module Statistics
  require_relative 'event'
  class EventFactory
    def initialize
      @cid = 0
    end

    def build(type, time, cid = (cid_not_passed = true; @cid))
      @cid += 1 if cid_not_passed
      Event.new(type, time, cid)
    end
  end
end
