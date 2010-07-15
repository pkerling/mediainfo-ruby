require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new("mediainfo-ruby", "0.1.4") do |p|
	p.description = "MediaInfo Ruby Bridge. Call MediaInfo lib directly"
	p.url         = "http://github.com/hackerdude/mediainfo-ruby"
	p.author      = "David Martinez"
	p.ignore_pattern = ["tmp/*", "script/*", "pkg/*"]
	p.development_dependencies = [] # TODO How to do native dependencies?
end


Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each{|ext| load ext }
