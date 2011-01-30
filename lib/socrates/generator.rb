require 'tilt'

require_relative 'models/information'
require_relative 'models/schedule'
require_relative 'models/assignments'
require_relative 'models/invocation'
require_relative 'models/theme'

require_relative 'controllers/site_controller.rb'

module Socrates
	class Generator
		attr_reader :information
		attr_reader :assignments
		attr_reader :invocation
		attr_reader :theme
		attr_reader :schedule

		def initialize(files = {})
			if not files.keys.include? :invocation
				files[:invocation] = './invocation.yml'
			end
			if not files.keys.include? :theme
				files[:theme] = './theme.yml'
			end

			@config = YAML.load_file(files[:invocation])

			if not Socrates.settings.keys.include? :course_path
				if @config["course path"]
					course_path = @config["course path"]
				else
					course_path = '.'
				end
			else
				course_path = Socrates.settings[:course_path]
			end

			if not files.keys.include? :information
				files[:information] = course_path + '/information.yml'
			end
			if not files.keys.include? :schedule
				files[:schedule] = course_path + '/schedule.yml'
			end
			if not files.keys.include? :assignments
				files[:assignments] = course_path + '/assignments.yml'
			end

			@assignments = Models::Assignments.load(files[:assignments])
			@information = Models::Information.load(files[:information])
			@invocation = Models::Invocation.load(@assignments, files[:invocation])
			@schedule = Models::Schedule.load(@invocation, files[:schedule])

			@theme = Models::Theme.load(files[:theme])
		end

		def generate(destination = '.')
			# Render

			@theme_path = File.dirname(__FILE__) + '/views/' + @theme.name

			# Common Files
			@common_files = []
			Dir.new(@theme_path + "/common").each do |f|
				if f[0] != '.' and not File.directory?(@theme_path + "/common/" + f)
					filename = f[0..f.rindex('.')-1]
					@common_files << filename.intern
				end
			end

			load_common(@theme_path + "/common/header.haml", @theme_path + "/common/footer.haml")

			def traverse(start_path, start_dest, traversed = '.')
				path = start_path + "/" + traversed
				dest = start_dest + "/" + traversed

				path_to_root = "../" * traversed.count('/')

				Dir.new(path).each do |f|
					if f[0] != '.' and not f == "common"
						if File.directory?(path + "/" + f)
							FileUtils.mkdir_p dest + "/" + f
							traverse(start_path, start_dest, traversed + "/" + f)
						else
							filename = f[0..f.rindex('.') - 1]
							ext = f[f.rindex('.')+1..-1]
							case ext
							when 'sass' # Render these to CSS
								new_ext = 'css'
							when 'haml', 'md' # Render these to HTML
								new_ext = 'html'
							when 'yml' # Skip YAML configuration files
								next
							else # The rest is just moved (.js, etc)
								new_ext = ext
							end

							if new_ext != ext
								puts "Creating " + traversed + "/" + filename + "." + new_ext
								foo = render(path + "/" + f, path_to_root)

								commit(foo, dest + "/" + filename + "." + new_ext)
							else
								puts "Copying " + f
								FileUtils.cp path + "/" + f, dest + "/" + f
							end
						end
					end
				end
			end

			# Rake the rest of the files
			traverse(@theme_path, destination)
		end

		def commit(output, path)
			File.open(path, "w") do |f|
				f.write output
			end
		end
		private :commit

		def load_common(header_file, footer_file)
			# header file
			@header = File.read(header_file)

			start_index = @header.rindex(/\n/m, -2)+1
			@header_indent = @header[start_index..@header.index(/\S/, start_index)-1]

			# footer file
			@footer = "= Tilt::HamlTemplate.new(@theme_path + '/common/footer.haml').render self"
		end
		private :load_common
		
		def render(file, path)
			controller = Socrates::Controllers::SiteController.new(self, '', path, @theme_path)

			# Controller methods for common files
			@common_files.each do |common|
				if controller.public_methods.include? common
					controller.send common
				end
			end

			# Render the file
			filename = file[0..file.rindex('.') - 1]
			filename = filename[filename.rindex('/')+1..-1]
			ext = file[file.rindex('.')+1..-1]

			p filename.intern
			if controller.public_methods.include? filename.intern
				controller.send filename.intern
			end

			case ext
			when 'sass'
				template = Tilt.new(file)
			when 'haml', 'md'
				content = @header + "\n" + @header_indent

				if ext == "md"
					content = content + ":markdown"
					md_content = File.read(file)
					content = content + md_content.lines.inject("") do |result, line|
						result + "\n" + @header_indent + "  " + line
					end
				else
					content = content + "= Tilt::HamlTemplate.new('#{file}').render self"
				end

				content = content + "\n" + @header_indent + @footer

				puts content
				template = Tilt::HamlTemplate.new(nil, 1, {:format => :html5}) do
					content
				end
			else
				# unknown
				return
			end

			template.render controller
		end
		private :render
	end
end
