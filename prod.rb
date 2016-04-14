require "rubygems"
require "sinatra"
require "sinatra/cookies"
require "./RandomVector"
require "./local.rb"

include Localization

get '/' do
	redirect to("/uk")
end

get '/:lang' do |l|

	@lang = l.to_sym
	@lang = session[:lang] if session.has_key? :lang

	@local = Local[@lang]

	erb :index
	
end

post "/:lang/calc" do |l|

	return redirect to("/#{l}"), 301 if params[:re] == "1"

	@lang = l.to_sym
	@lang = session[:lang] if session.has_key? :lang

	@local = Local[@lang]

	arr = params[:matrix].split("\n")

	@n = params[:n].to_i
	@m = params[:m].to_i

	@x_xi = params[:xi].split.map(&:to_f)
	@x_eta = params[:eta].split.map(&:to_f)

	@p = []

	@n.times do |i|
		@p[i] = arr[i].split.map(&:to_f)
	end

	@vec = RandomVector.new

	@vec.set_vector @p, @x_xi, @x_eta

	@xi = @vec.xi
	@eta = @vec.eta

	@f_xi = process(@xi.distribution, @xi.vals, "x")
	@f_eta = process(@eta.distribution, @eta.vals, "y")

	erb :answer

end