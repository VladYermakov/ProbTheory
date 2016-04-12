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

<table class="matrix">
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
<table class="matrix">
	<tr>
		<td>Mξ</td>
		<td>Mη</td>
		<td>Dξ</td>
		<td>Dη</td>
	</tr>
	<tr>
		<td><%= expected_value(@xi).round(4).to_s %></td>
		<td><%= expected_value(@eta).round(4).to_s %></td>
		<td><%= variance(@xi).round(4).round(4).to_s %></td>
		<td><%= variance(@eta).round(4).round(4).to_s %></td>
	</tr>
</table>
<form method=GET><input type="submit" value=Back></form>