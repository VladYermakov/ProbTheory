 class RandomVariable

	attr_reader :vals, :probs

	def initialize

		@vals = []
		@probs = []
		@len = 0

		self

	end

	def q
		@vals
	end

	def copy!(other)

		@vals = other.vals.clone
		@probs = other.probs.clone
		@len = other.size

		self

	end

	def self.from_other (other) 

		ans = RandomVariable.new
		ans.copy! other

		ans

	end

	def self.with_params(_vals, _probs)

		ans = RandomVariable.new

		ans.set_variable! _vals, _probs

	end

	def set_variable!(_vals, _probs)

		@vals = _vals
		@probs = _probs
		@len = _vals.size - 1

		self

	end

	def size

		@len

	end

	def vals_plus_equal(i, x)

		@vals[i] += x

	end

	def vals_mult_equal(i, x)

		@vals[i] *= x

	end

	def vals_power_equal(i, x)

		@vals[i] **= x

	end

	def val(i)

		@vals[i]

	end

	def prob(i)

		@probs[i]

	end

	def +(x)

		ans = RandomVariable.from_other self

		for i in 1..size do

			ans.vals_plus_equal i, x

		end

		ans

	end

	def -(x)

		ans = RandomVariable.from_other self

		for i in 1..size do

			ans.vals_plus_equal i, -x

		end

		ans

	end

	def *(x)

		ans = RandomVariable.from_other self

		for i in 1..size do

			ans.vals_mult_equal i, x

		end

		ans

	end

	def /(x)

		ans = RandomVariable.from_other self

		for i in 1..size do

			ans.vals_mult_equal i, 1.0 / x

		end

		ans

	end

	def **(x)

		ans = RandomVariable.from_other self

		for i in 1..size do

			ans.vals_power_equal i, x

		end

		ans

	end

	def distribution

		ans = [0]

		for i in 1..size do

			x = ans[i - 1] + @probs[i]

			ans += [x]

		end

		ans

	end

	def method_missing(method_name, *args, &block)

		if @probs.respond_to? method_name
		
			@probs.send method_name, *args

		else
		
			super method_name, *args, &block

		end

	end

	def inspect
		"val: " + vals.inspect + "\n" + "p:   " + probs.inspect
	end


end

def expected_value(variable)

	ans = 0

	for i in 1..variable.size do

		ans += variable.val(i) * variable.prob(i)

	end

	ans

end

def central_moment(variable, order)

	m = expected_value(variable)

	expected_value((variable - m) ** order)

end

def variance(variable)

	central_moment variable, 2

end

def standard_deviation(variable)

	Math.sqrt(variance(variable))

end

def raw_moment(variable, order)

	expected_value(variable ** order)

end

def mode(variable)

	variable.val(variable.index(variable.max))

end

def median(variable)

	f = variable.distribution

	variable.val(f.index{|x| x * 2 >= 1})

end

def skewness(variable)

	central_moment(variable, 3) / (standard_deviation(variable) ** 3)

end

def kurtosis(variable) 

	(central_moment(variable, 4) / (standard_deviation(variable) ** 4)) - 3

end

=begin
n = gets.to_i

x = [0.0] + gets.split.map{|q| q.to_f}

p = [0.0] + gets.split.map{|q| q.to_f}

var = RandomVariable.with_params(x, p)

puts expected_value(var)
=end
