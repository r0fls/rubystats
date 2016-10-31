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

class Geometric < Distribution
    def initialize(p)
        @p = p
    end
    def pmf(k)
        return @p * (1 - @p) ** (k-1)
    end
    def cdf(k)
        return 1 - (1 - @p) ** k
    end
    def quantile(p)
        return (Math.log(1-p) / Math.log(1-@p)).ceil
    end
end

class Laplace < Distribution
    def initialize(m, b)
        @m = m
        @b = b
    end
    def pdf(x)
        return Math.exp(-((x - @m).abs) / @b) / (2*@b)
    end
    def cdf(x)
        if x < @m then
            return Math.exp((x - @m) / @b) / 2
        elsif x >= @m
            return 1 - Math.exp(-(x - @m) / @b) / 2
        end
    end
    def quantile(p)
        if p > 0 and p <= 0.5 then
            return @m + @b*Math.log(2*p)
        elsif p > 0.5 && p < 1 then
            return @m - @b*Math.log(2*(1-p))
        else
            raise ArgumentError.new("Wrong domain")
        end
    end
end

class Poisson < Distribution
    def initialize(m)
        @m = m
    end
    def pmf(k)
        return (@m ** k) * Math.exp(-@m) / Math.gamma(k+1)
    end
    def cdf(k)
        total = 0
        for i in (0..k)
            total += self.pmf(i)
        end
        return total
    end
    def quantile(p)
        total = 0
        j = 0
        while total < p
            j += 1
            total += self.pmf(j)
        end
        return j
    end
end
