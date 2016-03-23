module Statistics
  require 'csv'
  class Exp
    def initialize(lam, eps, b, a=(b*-1))
      @lam = lam
      @eps = eps
      @a = a
      @b = b
      @last = nil
    end

    def generate(u = rand)
      # If not first iteration
      if @last
        v = get_vn(u)
        u = (@last + v) % 1
      end

      transform(stitch(u))
    end

    def transform(u)
      @last = u
      x = -(1.to_f / @lam) * Math.log(1 - u)
    end

    private
    def get_vn(u)
      @a + (@b - @a) * u
    end

    def stitch(r)
      if (r >= 0 && r <= @eps)
        r.to_f / @eps
      elsif (r > @eps && r<= 1)
        (1 - r).to_f / (1 - @eps)
      else
        raise "Stitching transformation received invalid input: #{r}"
      end
    end

    if __FILE__ == $0
      e = Exp.new(5, 0.7, 0.5)
      e.generate
      #Test some exponential numbers
      CSV.open("./data.csv","w") do |csv|
        csv << ['data']
      end
      10000.times do
        CSV.open("./data.csv", "a") do |csv|
          n = e.generate
          csv << [n]
        end
      end
    end
  end
end
