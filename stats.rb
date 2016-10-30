class Distribution
    def Random
        if @Random == nil then
            @Random = Random.new()
        end
        @Random
    end
    def seed(value=nil)
        if value != nil then
            @Random = Random.new(value)
        else
            @Random = Random.new()
        end
    end
    def rand(n=1)
        if n == 1
            return self.quantile(self.Random.rand)
        elsif n > 1 and n.is_a? Integer then
            return (1..n).map{self.quantile(self.Random.rand)}
        else
            raise ArgumentError.new("The number of points to generate should be an integer greater than 1.")
        end
    end
end

class Bernoulli < Distribution
    def initialize(p)
        @p = p
    end

    def pmf(k)
        if k == 0 then
            return 1 - @p
        elsif k == 1 then
            return @p
        else
            return Float::NAN
        end
    end
    def cdf(k)
        if k == 0 then
            return 1 - @p
        elsif k == 1 then
            return 1
        else
            return Float::NAN
        end
    end
    def quantile(p)
        if p >= 0 and p < 1 - @p then
            return 0
        elsif p <= 1 then
            return 1
        else
            return Float::NaN
        end
    end
end
