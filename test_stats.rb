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
