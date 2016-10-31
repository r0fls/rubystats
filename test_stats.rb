require "./stats"
require "test/unit"

def is_close(num1, num2, allowed=9)
    if (num1*10**allowed).round == (num2 * 10**allowed).round then
        return true
    else
        return false
    end
end

class TestBernoulli < Test::Unit::TestCase
    def test_bernoulli_pmf
        bern = Bernoulli.new(0.7)
        assert_true(is_close(0.7, bern.pmf(1)))
        assert_true(is_close(0.3, bern.pmf(0)))
    end
    def test_bernoulli_cdf
        bern = Bernoulli.new(0.7)
        assert_true(is_close(1, bern.cdf(1)))
        assert_true(is_close(0.3, bern.cdf(0)))
    end
    def test_bernoulli_quantile
        bern = Bernoulli.new(0.7)
        assert_equal(0, bern.quantile(0.2))
        assert_equal(1, bern.quantile(0.4))
    end
    def test_bernoulli_rand
        bern = Bernoulli.new(0.7)
        bern.seed(1)
        assert_equal(1, bern.rand)
    end
end

class TestGeometric < Test::Unit::TestCase
    def test_geometric_pmf
        geom = Geometric.new(0.2)
        assert_true(is_close(0.08192000000000005, geom.pmf(5)))
    end
    def test_geometric_cdf
        geom = Geometric.new(0.2)
        assert_true(is_close(0.8926258175999999, geom.cdf(10)))
    end
    def test_geometric_quantile
        geom = Geometric.new(0.2)
        assert_equal(4, geom.quantile(0.5))
    end
    def test_geometric_rand
        geom = Geometric.new(0.2)
        geom.seed(1)
        assert_equal(3, geom.rand)
    end
end

class TestPoisson < Test::Unit::TestCase
    def test_poisson_pmf
        poisson = Poisson.new(5)
        assert_true(is_close(0.1754673697678507, poisson.pmf(5)))
    end
    def test_poisson_cdf
        poisson = Poisson.new(5)
        assert_true(is_close(0.9863047314016171, poisson.cdf(10)))
    end
    def test_poisson_quantile
        poisson = Poisson.new(5)
        assert_equal(5, poisson.quantile(0.5))
    end
    def test_poisson_rand
        poisson = Poisson.new(5)
        poisson.seed(1)
        assert_equal(4, poisson.rand)
    end
end

class TestBinomial < Test::Unit::TestCase
    def test_binomial_pmf
        binomial = Binomial.new(10, 0.5)
        assert_true(is_close(0.24609375, binomial.pmf(5)))
    end
    def test_binomial_cdf
        binomial = Binomial.new(10, 0.5)
        assert_true(is_close(1, binomial.cdf(10)))
    end
    def test_binomial_quantile
        binomial = Binomial.new(10, 0.5)
        assert_equal(5, binomial.quantile(0.5))
    end
    def test_binomial_rand
        binomial = Binomial.new(10, 0.5)
        binomial.seed(1)
        assert_equal(5, binomial.rand)
    end
end

class TestNormal < Test::Unit::TestCase
    def test_normal_pmf
        normal = Normal.new(0, 1)
        assert_true(is_close(0.3989422804014327, normal.pdf(0)))
    end
    def test_normal_cdf
        normal = Normal.new(0, 1)
        assert_true(is_close(0.5, normal.cdf(0)))
    end
    def test_normal_quantile
        normal = Normal.new(0, 1)
        assert_true(is_close(1.2815515655446004, normal.quantile(0.9)))
    end
    def test_normal_rand
        normal = Normal.new(0, 1)
        normal.seed(1)
        assert_equal(-0.2095178409162432, normal.rand)
    end
end

class TestExponential < Test::Unit::TestCase
    def test_exponential_pmf
        exponential = Exponential.new(0.2)
        assert_true(is_close(0.07357588823428847, exponential.pdf(5)))
    end
    def test_exponential_cdf
        exponential = Exponential.new(0.2)
        assert_true(is_close(0.8646647167633873, exponential.cdf(10)))
    end
    def test_exponential_quantile
        exponential = Exponential.new(0.2)
        assert_equal(3.465735902799726, exponential.quantile(0.5))
    end
    def test_exponential_rand
        exponential = Exponential.new(0.2)
        exponential.seed(1)
        assert_equal(2.698029186295927, exponential.rand)
    end
end

class TestLaplace < Test::Unit::TestCase
    def test_laplace_pmf
        laplace = Laplace.new(0, 1)
        assert_true(is_close(0.5, laplace.pdf(0)))
    end
    def test_laplace_cdf
        laplace = Laplace.new(0, 1)
        assert_true(is_close(0.5, laplace.cdf(0)))
    end
    def test_laplace_quantile
        laplace = Laplace.new(0, 1)
        assert_equal(0, laplace.quantile(0.5))
    end
    def test_laplace_rand
        laplace = Laplace.new(0, 1)
        laplace.seed(1)
        assert_equal(-0.18146910894470789, laplace.rand)
    end
end
