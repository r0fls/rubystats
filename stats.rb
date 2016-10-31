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

class Exponential < Distribution
    def initialize(l)
        @l = l
    end
    def pdf(x)
        return @l * Math.exp(-@l * x)
    end
    def cdf(x)
        return 1 - Math.exp(-@l * x)
    end
    def quantile(p)
        return -Math.log(1 - p) / @l
    end
end

class Binomial < Distribution
    def initialize(n, p)
        @n = n
        @p = p
    end
    def pmf(k)
        return choose(@n, k) * (@p ** k) * ((1 - @p) ** (@n - k))
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

class Normal < Distribution
    def initialize(m, v)
        @m = m
        @v = v
    end
    def pdf(x)
        return (1 / Math.sqrt(@v * 2 * Math::PI)) *
            Math.exp(-((x - @m) ** 2)/(2 * @v))
    end
    def cdf(x)
        return (1 + Math.erf((x - @m)/Math.sqrt(2 * @v))) / 2
    end
    def quantile(p)
        return @m + Math.sqrt(@v * 2)*erfinv(2 * p - 1)
    end
end

# Common functions

def choose(n, k)
    return Math.gamma(n + 1) / (Math.gamma(k + 1) * Math.gamma(n - k + 1))
end

def erfinv(y)
    center = 0.7
    a = [ 0.886226899, -1.645349621,  0.914624893, -0.140543331]
    b = [-2.118377725,  1.442710462, -0.329097515,  0.012229801]
    c = [-1.970840454, -1.624906493,  3.429567803,  1.641345311]
    d = [ 3.543889200,  1.637067800]
    if y.abs <= center then
        z = y ** 2
        numer = (((a[3]*z + a[2])*z + a[1])*z) + a[0]
        denom = ((((b[3]*z + b[2])*z + b[1])*z + b[0])*z + 1.0)
        x = y * numer / denom
        for _ in (0..5)
            x =  x - (Math.erf(x) - y)/(2.0/Math.sqrt(Math::PI)*Math.exp(-x*x))
        end
        return x
    elsif y.abs > center and y.abs < 1 then
        z = Math.sqrt(-Math.log(1.0 - y.abs) / 2)
        numer = ((c[3]*z + c[2])*z + c[1])*z + c[0]
        denom = (d[1]*z + d[0])*z + 1
        x = (y / y.abs) * numer / denom
        for _ in (0..5)
            x =  x - (Math.erf(x) - y)/(2.0/Math.sqrt(Math::PI)*Math.exp(-x*x))
        end
        return x
    elsif y.abs == 1 then
        return Float::INFINITY
    else
        raise ArgumentError.new("Invalid argument")
    end
end
