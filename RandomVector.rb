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
		s = "%.4f" % distribution[i]
		while s[-1] == "0"
			s = s[0..-2]
		end
		if s[-1] == "."
			s = s[0..-2]
		end
		s += ", "+@local[:if]+" "
		if i == 0
			s += "%s &le; %.4f" % [q, xi[i + 1].round(7)]
			while s[-1] == "0"
				s = s[0..-2]
			end
			if s[-1] == "."
			s = s[0..-2]
		end
		elsif i == n
			s += "%s > %.4f" % [q, xi[i].round(7)]
			while s[-1] == "0"
				s = s[0..-2]
			end
			if s[-1] == "."
			    s = s[0..-2]
			end
		else
			s += "%.4f" % xi[i].round(7)
			while s[-1] == "0"
				s = s[0..-2]
			end
			if s[-1] == "."
				s = s[0..-2]
			end
			s += " < %s &le; %.4f" % [q, xi[i + 1].round(7)]
			while s[-1] == "0"
				s = s[0..-2]
			end
			if s[-1] == "."
				s = s[0..-2]
			end
		end
		a[i + 1] = s
	end

	a

end

def process_xi_for_graph
	ans = []
	ans[0] = ['X', 'Fξ']
	f_xi = @xi.distribution
	ans[1] = [@xi.vals[1] - 1, 0]
	ans[2] = [@xi.vals[1], 0]
	(@n-1).times do |i|
		ans[i + 3] = [@xi.vals[i + 2], f_xi[i + 1]]
	end
	ans += [[@xi.vals[-1] + 1, 1]]
	@q_xi = ans[1][0]
	ans
end

def process_eta_for_graph
	ans = []
	ans[0] = ['X', 'Fη']
	f_eta = @eta.distribution
	ans[1] = [@eta.vals[1] - 1, 0]
	ans[2] = [@eta.vals[1], 0]
	(@m-1).times do |i|
		ans[i + 3] = [@eta.vals[i + 2], f_eta[i + 1]]
	end
	ans += [[@eta.vals[-1] + 1, 1]]
	@q_eta = ans[1][0]
	ans
end

=begin
ans = []
	ans[0] = ['X', 'Fη']
	f_eta = @eta.distribution
	ans[1] = [(@eta.vals[1] - 1).to_s, 0]
	ans[2] = [@eta.vals[1].to_s, 0]
	(@m-1).times do |i|
		ans[i + 3] = [@eta.vals[i + 2].to_s, f_eta[i + 1]]
	end
	ans += [[(@eta.vals[-1] + 1).to_s, 1]]
	@q_eta = ans[1][0]
	ans
=end