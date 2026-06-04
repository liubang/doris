#include <boost/random/mersenne_twister.hpp>
#include <boost/math/special_functions/fpclassify.hpp>
int main() {
    boost::random::mt19937 gen;
    return boost::math::isnan(1.0) ? 1 : 0;
}
