require 'yaml'
require_relative 'controller'

# Model

class Site
	attr_accessor :config
	attr_accessor :schedule

	def initialize(config_file, schedule_file, common)
		# Read the header
		@header = File.read('common/header.haml')

		start_index = @header.rindex(/\n/m, -2)+1
		@header_indent = @header[start_index..@header.index(/\S/, start_index)-1]

		# Open the configuration files
		self.config = YAML.load_file(config_file)
		self.schedule = YAML.load_file(schedule_file)

		@common = common
	end

	def render_sass(sass_file, prepend_path = "")
		# Get the title from the file name

		filename = sass_file[sass_file.rindex('/')+1..sass_file.rindex('.')-1]
		filename = filename.split('_').inject("") do |result, word|
			result + word.capitalize + " "
		end
		filename.strip!

		content = File.read(sass_file)

		# Render the sass
		template = Tilt.new(sass_file)
		template.render self
	end

	def render_md(md_file, prepend_path = "")
		# Get the title from the file name

		filename = md_file[md_file.rindex('/')+1..md_file.rindex('.')-1]
		
		content = @header + @header_indent
		content = content + ":markdown"

		md_content = File.read(md_file)
		content = content + md_content.lines.inject("") do |result, line|
			result + "\n" + @header_indent + "  " + line
		end

		content = content + "\n" + @header_indent
		content = content + "= Tilt::HamlTemplate.new('common/footer.haml').render self"

		# Render the haml
		template = Tilt::HamlTemplate.new(nil, 1, {:format => :html5}) do
			content
		end

		title = filename.split('_').inject("") do |result, word|
			result + word.capitalize + " "
		end
		title.strip!

		controller = Controller.new(self, title, prepend_path)

		@common.each do |method|
			if controller.public_methods.include?(method)
				controller.send method
			end
		end

		template.render controller
	end

	def render_haml(haml_file, prepend_path = "")
		# Get the title from the file name

		filename = haml_file[haml_file.rindex('/')+1..haml_file.rindex('.')-1]
		
		content = @header + @header_indent
		content = content + "= Tilt::HamlTemplate.new('#{haml_file}').render self"
		content = content + "\n" + @header_indent
		content = content + "= Tilt::HamlTemplate.new('common/footer.haml').render self"

		# Render the haml
		template = Tilt::HamlTemplate.new(nil, 1, {:format => :html5}) do
			content
		end

		title = filename.split('_').inject("") do |result, word|
			result + word.capitalize + " "
		end
		title.strip!

		controller = Controller.new(self, title, prepend_path)

		@common.each do |method|
			if controller.public_methods.include?(method)
				controller.send method
			end
		end

		if controller.public_methods.include?(filename.intern)
			controller.send filename
		end

		template.render controller
	end
end
