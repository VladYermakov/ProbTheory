require "rubygems"
require "sinatra"
require "./RandomVector"

get '/' do

	erb :index
	
end

post "/" do

	arr = params[:matrix].split("\n")

	@n, @m = arr[0].split.map(&:to_i)

	@x_xi = arr[1].split.map(&:to_f)
	@x_eta = arr[2].split.map(&:to_f)

	@p = []

	@n.times do |i|
		@p[i] = arr[i + 3].split.map(&:to_f)
	end

	@vec = RandomVector.new

	@vec.set_vector @p, @x_xi, @x_eta

	@xi = @vec.xi
	@eta = @vec.eta

	@f_xi = process(@xi.distribution, @xi.vals, "x")
	@f_eta = process(@eta.distribution, @eta.vals, "y")

	erb :answer

end

__END__

@@ layout
<!DOCTYPE html>
<html>
	<head>
		<title>Sinatra project</title>
		<link rel=stylesheet href="/assets/style.css">
	</head>
	<body>
		<%= yield %>
		<!--audio controls="controls" autoplay loop>
			<source src="/music/testsong.mp3">
		</audio-->
	</body>
</html>

@@ index
<form method=POST>
	<label><p>Enter the matrix</p> <textarea name=matrix cols=40 rows=5></textarea></label><br>
	<input type=submit>
</form>

@@ answer
<div class="matrix">
	<table>
		<tr>
			<td>ξ\η</td>
			<% @m.times do |i| %>
				<td><%= @x_eta[i + 1] %></td>
			<% end %>
		</tr>
		<% @n.times do |i| %>
			<tr>
				<td><%= @x_xi[i + 1] %></td>
				<% @m.times do |j|%>
					<td><%= @p[i][j] %></td>
				<% end %>
			</tr>
		<% end %>
	</table>
</div>
<div class=mx>
	<p>F<sub>ξ</sub></p>
	<table>
		<% (@n+1).times do |i| %>
			<tr>
				<td><%= @f_xi[i + 1] %></td>
			</tr>
		<% end %>
	</table>
</div>
<br>
<div class=mx>
	<p>F<sub>η</sub></p>
	<table>
		<% (@m+1).times do |i| %>
			<tr>
				<td><%= @f_eta[i + 1] %></td>
			</tr>
		<% end %>
	</table>
</div>
<div class=matrix>
	<table>
		<tr>
			<td>Mξ</td>
			<td>Mη</td>
			<td>Dξ</td>
			<td>Dη</td>
			<td>σξ</td>
			<td>ση</td>
			<td>Moξ</td>
			<td>Moη</td>
			<td>Meξ</td>
			<td>Meη</td>
			<td>Asξ</td>
			<td>Asη</td>
			<td>Ekξ</td>
			<td>Ekη</td>
			<td>covξη</td>
			<td>rξη</td>
		</tr>
		<tr>
			<td><%= expected_value(@xi).round(7).to_s %></td>
			<td><%= expected_value(@eta).round(7).to_s %></td>
			<td><%= variance(@xi).round(7).round(7).to_s %></td>
			<td><%= variance(@eta).round(7).round(7).to_s %></td>
			<td><%= standard_deviation(@xi).round(7).to_s %></td>
			<td><%= standard_deviation(@eta).round(7).to_s %></td>
			<td><%= mode(@xi).round(7).to_s %></td>
			<td><%= mode(@eta).round(7).to_s %></td>
			<td><%= median(@xi).round(7).to_s %></td>
			<td><%= median(@eta).round(7).to_s %></td>
			<td><%= skewness(@xi).round(7).to_s %></td>
			<td><%= skewness(@eta).round(7).to_s %></td>
			<td><%= kurtosis(@xi).round(7).to_s %></td>
			<td><%= kurtosis(@eta).round(7).to_s %></td>
			<td><%= cov(@vec).round(7).to_s %></td>
			<td><%= dependence(@vec).round(7).to_s %></td>
		</tr>
	</table>
</div>
<form method=GET><input type="submit" value=Back></form>