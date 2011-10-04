require 'tilt'

require 'socrates/models/information'
require 'socrates/models/schedule'
require 'socrates/models/assignments'
require 'socrates/models/invocation'
require 'socrates/models/theme'

require 'socrates/controllers/site_controller'

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
          @course_path = @config["course path"]
        else
          @course_path = '.'
        end
      else
        @course_path = Socrates.settings[:course_path]
      end

      if not files.keys.include? :information
        files[:information] = @course_path + '/information.yml'
      end
      if not files.keys.include? :schedule
        files[:schedule] = @course_path + '/schedule.yml'
      end
      if not files.keys.include? :assignments
        files[:assignments] = @course_path + '/assignments.yml'
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

      @theme_imports = YAML.load_file(@theme_path + "/imports.yml")["import"]
      unless @theme_imports.is_a? Array
        @theme_imports = [@theme_imports]
      end

      # Common Files
      @common_files = []
      Dir.new(@theme_path + "/common").each do |f|
        if f[0] != '.' and not File.directory?(@theme_path + "/common/" + f)
          filename = f[0..f.rindex('.')-1]
          @common_files << filename.intern
        end
      end

      load_common(@theme_path + "/common/header.haml",
                  @theme_path + "/common/slide_header.haml",
                  @theme_path + "/common/footer.haml",
                  @theme_path + "/common/slide_footer.haml")

      def traverse(start_path, start_dest, traversed = '.')
        path = start_path + "/" + traversed
        dest = start_dest + "/" + traversed

        path_to_root = "../" * traversed.count('/')

        Dir.new(path).each do |f|
          if f[0] != '.' and not f == "common"
            if f == "assignments.haml" and traversed == '.'
              assignments.types.each do |type|
                puts "Creating ./" + type + ".html"
                foo = render(path + "/" + f, path_to_root, type)
                commit(foo, dest + "/" + type + ".html")
              end
            elsif File.directory?(path + "/" + f)
              FileUtils.mkdir_p dest + "/" + f
              traverse(start_path, start_dest, traversed + "/" + f)
            else
              filename = f[0..f.rindex('.') - 1]
              ext = f[f.rindex('.')+1..-1]
              case ext
              when 'sass', 'scss' # Render these to CSS
                new_ext = 'css'
              when 'haml', 'md', 'slides' # Render these to HTML
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
                puts "Copying " + traversed + "/" + filename + "." + ext
                FileUtils.cp path + "/" + f, dest + "/" + f
              end
            end
          end
        end
      end

      # Rake the rest of the files
      traverse(@theme_path, destination)

      # Rake theme imports
      @theme_imports.each do |i|
        import_path = File.dirname(__FILE__) + '/views/shared/' + i
        traverse(import_path, destination)
      end

      # Rake course files
      traverse(@course_path, destination)
    end

    def commit(output, path)
      File.open(path, "w") do |f|
        f.write output
      end
    end
    private :commit

    def load_common(header_file, slide_header_file, footer_file, slide_footer_file)
      # header file
      @header = File.read(header_file)
      @slide_header = File.read(slide_header_file)

      start_index = @header.rindex(/\n/m, -2)+1
      @header_indent = @header[start_index..@header.index(/\S/, start_index)-1]

      start_index = @slide_header.rindex(/\n/m, -2)+1
      @slide_header_indent = @slide_header[start_index..@slide_header.index(/\S/, start_index)-1]

      # footer file
      @footer = "= Tilt::HamlTemplate.new('#{footer_file}').render self"
      @slide_footer = "= Tilt::HamlTemplate.new('#{slide_footer_file}').render self"
    end
    private :load_common
    
    def render(file, path, type = '')
      filename = file[0..file.rindex('.') - 1]
      filename = filename[filename.rindex('/')+1..-1]
      ext = file[file.rindex('.')+1..-1]

      if type == ''
        title = filename.split('_').inject("") do |result, word|
          result + word.capitalize + " "
        end
        title.strip!
      else
        title = type.capitalize
      end

      controller = Socrates::Controllers::SiteController.new(self, title, path, @theme_path)

      # Controller methods for common files
      @common_files.each do |common|
        if controller.public_methods.include? common
          controller.send common
        end
      end

      # Render the file
      if controller.public_methods.include? filename.intern
        if type != ''
          controller.send filename.intern, (type)
        else
          controller.send filename.intern
        end
      end

      case ext
      when 'sass', 'scss'
        template = Tilt.new(file)
      when 'slides'
        content = @slide_header + "\n" + @slide_header_indent

        content = content + ".markdown" + "\n" + @slide_header_indent + "  " + ":markdown"
        md_content = File.read(file)
        content = content + md_content.lines.inject("") do |result, line|
          result + "\n" + @slide_header_indent + "    " + line
        end

        content = content + "\n" + @slide_header_indent + @slide_footer

        template = Tilt::HamlTemplate.new(nil, 1, {:format => :html5}) do
          content
        end

      when 'haml', 'md'
        content = @header + "\n" + @header_indent

        if ext == "md"
          content = content + ".markdown" + "\n" + @header_indent + "  " + ":markdown"
          md_content = File.read(file)
          content = content + md_content.lines.inject("") do |result, line|
            result + "\n" + @header_indent + "    " + line
          end
        else
          content = content + "= Tilt::HamlTemplate.new('#{file}').render self"
        end

        content = content + "\n" + @header_indent + @footer

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
