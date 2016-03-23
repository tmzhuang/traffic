module Statistics
  class Event
    attr_accessor :type, :time, :cid
    def initialize(type, time, cid)
      @type = type
      @time = time
      @cid = cid
    end
  end
end
