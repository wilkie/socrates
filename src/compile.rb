require 'tilt'
require 'haml'
require 'fileutils'

require_relative 'site'

def commit(output, filename)
	if File.exists?("output/#{filename}")
		File.delete("output/#{filename}")
	end

	File.open("output/#{filename}", "w") do |f|
		f.write output
	end
end

# Get a list of all of the common haml files
#
# This is so we can set up the controller correctly

common_files = []

Dir.new("common").each do |f|
	if f[0] != '.' and not File.directory?("common/" + f)
		filename = f[0..f.rindex('.')-1]
		common_files << filename.intern
	end
end

# Establish the Model

site = Site.new('course/information.yml', 'course/schedule.yml', common_files)

# CSS files are done first

Dir.new("css").each do |f|
	if f[0] != '.' and not File.directory?("css/" + f)
		filename = f[0..f.rindex('.')-1]
		puts "Creating " + filename + ".css"
		output = site.render_sass('css/' + f)
		commit(output, 'css/' + filename + '.css')
	end
end

# Each html file is generated next

Dir.new("html").each do |f|
	if f[0] != '.' and not File.directory?("html/" + f)
		filename = f[0..f.rindex('.')-1]
		puts "Creating " + filename + ".html"
		output = site.render_haml('html/' + f)
		commit(output, filename + '.html')
	end
end

# Render content
FileUtils.mkdir_p "output/content"
Dir.new("course/content").each do |f|
	if f[0] != '.' and not File.directory?("course/content/" + f)
		filename = f[0..f.rindex('.')-1]
		puts "Creating " + filename + ".html"
		output = site.render_md('course/content/' + f, "../")
		commit(output, 'content/' + filename + '.html')
	end
end

# Copy static/ verbatim to output

Dir.new("static").each do |f|
	if f[0] != '.'
		FileUtils.cp_r "static/" + f, "output/."
	end
end
