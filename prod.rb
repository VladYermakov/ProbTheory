require "rubygems"
require "sinatra"

get '/' do

	erb :index
	
end

post "/" do

	arr = params[:matrix].split("\n")

	@n = arr[0].to_i

	@m = []

	@n.times do |i|
		@m[i] = arr[i + 1].split
	end

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
	<% @n.times do |i| %>
		<tr>
			<% @n.times do |j|%>
				<td><%= @m[i][j] %></td>
			<% end %>
		</tr>
	<% end %>
</table>
<form method=GET><input type="submit" value=Back></form>