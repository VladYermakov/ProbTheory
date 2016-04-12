require_relative "RandomVariable"

class RandomVector

	attr_accessor :xi, :eta, :n, :m

	def initialize

		@xi = RandomVariable.new
		@eta = RandomVariable.new
		@matrix = [[]]

		@n = 0
		@m = 0

	end

	def probs(i, j)
		@matrix[i - 1][j - 1]
	end

	def process_xi(x)

		p = []

		@n.times do |i|
			p[i] = 0
		end

		@n.times do |i|
			@m.times do |j|
				p[i] += @matrix[i][j]
			end
		end

		x.unshift 0
		p.unshift 0

		@xi = RandomVariable.with_params(x, p)

	end

	def process_eta(x)

		p = []

		@m.times do |i|
			p[i] = 0
		end

		@n.times do |i|
			@m.times do |j|
				p[j] += @matrix[i][j]
			end
		end

		x.unshift 0
		p.unshift 0

		@eta = RandomVariable.with_params(x, p)

	end

	def set_vector(_matrix, x_xi, x_eta)

		@n = _matrix.size
		@m = _matrix[0].size
=begin
		@matrix = []
		
		q = [0] * (@m + 1)

		@n.times do |i|
			_matrix[i].unshift 0
		end

		_matrix.unshift q
=end
		@matrix = _matrix

		process_xi(x_xi)
		process_eta(x_eta)

	end

	def inspect
		"          xi\n" + xi.inspect + "\n          eta\n" + eta.inspect
	end

end

def cov(vector)

	ans = 0.0

	var_xi = vector.xi
	var_eta = vector.eta

	m_xi = expected_value var_xi
	m_eta = expected_value var_eta

	n = var_xi.size
	m = var_eta.size

	for i in 1..var_xi.size
		for j in 1..var_eta.size
			ans += (var_xi.vals[i] - m_xi) * (var_eta.vals[j] - m_eta) * vector.probs(i, j)
		end
	end

	ans

end

def dependence(vector)

	xi = vector.xi
	eta = vector.eta

	cov(vector) / (standard_deviation(xi) * standard_deviation(eta))

end

def process(distribution, xi, q)

	n = distribution.size - 1

	a = []

	a[0] =  ""

	for i in 0..n
		a[i + 1] = "%.4f, при " % distribution[i]
		if i == 0
			a[i + 1] += "%s <= %.4f" % [q, xi[i + 1]]
		elsif i == n
			a[i + 1] += "%s > %.4f" % [q, xi[i]]
		else
			a[i + 1] += "%.4f < %s <= %.4f" % [xi[i], q, xi[i + 1]]
		end
		#a[i + 1] += "\n"
	end

	a

end

=begin
rv = RandomVector.new

printf "Введіть n і m: "
n, m = gets.split.map(&:to_i)

printf "Введіть ξ: "
xi = gets.split.map(&:to_f)
printf "Введіть η: "
eta = gets.split.map(&:to_f)

puts "Введіть матрицю випадкового вектора: "
a = []

n.times do |i|
	a[i] = gets.split.map(&:to_f)
end

rv.set_vector a, xi, eta

xi = rv.xi
eta = rv.eta

process(xi.distribution, xi.vals, "x")

process(eta.distribution, eta.vals, "y")

puts

puts "Mξ = " + expected_value(xi).round(4).to_s
puts "Mη = " + expected_value(eta).round(4).to_s

puts "Dξ = " + variance(xi).round(4).round(4).to_s
puts "Dη = " + variance(eta).round(4).round(4).to_s

puts "σξ = " + standard_deviation(xi).round(4).to_s
puts "ση = " + standard_deviation(eta).round(4).to_s

puts "Moξ = " + mode(xi).round(4).to_s
puts "Moη = " + mode(eta).round(4).to_s

puts "Meξ = " + median(xi).round(4).to_s
puts "Meη = " + median(eta).round(4).to_s

puts "Asξ = " + skewness(xi).round(4).to_s
puts "Asη = " + skewness(eta).round(4).to_s

puts "Ekξ = " + kurtosis(xi).round(4).to_s
puts "Ekη = " + kurtosis(eta).round(4).to_s

puts "rξη = " + dependence(rv).round(4).to_s

gets
=end
#37ead887-5d59-4665-86ee-946a590f9d3a

=begin
3 2
3 10 12
4 5
0.17 0.10
0.13 0.30
0.25 0.05
=end