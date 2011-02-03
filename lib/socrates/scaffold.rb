require 'fileutils'

module Socrates
	class << self
		def scaffold(course_name)
			if not File.exists?(course_name)
				FileUtils.mkdir course_name
			else
				warn course_name + " already exists"
				return
			end

			File.open(course_name + "/assignments.yml", "w") do |f|
				f.write "# assignments.yml\n"
				f.write "\n"
				f.write "# In this file, list all of the assignments, projects, labs, etc.\n"
				f.write "# There is a simple convention. Any header (in the following, this is \"homework\") will\n"
				f.write "#   be considered it's own section. A separate page will be produced for each section.\n"
				f.write "#   The course invocation will pick the due dates of each assignment.\n"
				f.write "\n"
				f.write "# For each, list a title, a description, and a link to the assignment write-up.\n"
				f.write "\n";
				f.write "# Example:\n"
				f.write "\n";
				f.write "homework:\n"
				f.write "  - title: Chapter 2\n"
				f.write "    description: Problem set for Chapter 2\n"
				f.write "    href: homework/c2.html\n" 
				f.write "  - title: Chapter 3\n"
				f.write "    description: Problem set of Chapter 3\n"
				f.write "    href: homework/c3.html\n"
				f.write "\n"
				f.write "# labs:\n"
				f.write "#   - title: Newton's Laws\n"
				f.write "#     description: We will review and experiment with the 3rd law.\n"
				f.write "#     href: labs/newton.html\n"
			end

			File.open(course_name + "/information.yml", "w") do |f|
				f.write "# information.yml\n"
				f.write "\n"
				f.write "# Right now the only information for the course is the course name\n"
				f.write "title: Introduction to Chemistry\n"
			end

			File.open(course_name + "/schedule.yml", "w") do |f|
				f.write "# schedule.yml\n"
				f.write "\n"
				f.write "# In this file, the schedule of the course is described. That is, this contains the\n"
				f.write "#   layout and order of the course materials. The invocation will contain the\n"
				f.write "#   dates of the class session and the schedule will be built such that each\n"
				f.write "#   lecture maps to a valid class date.\n"
				f.write "\n"
				f.write "# The syntax is easy. Just describe each lecture as a bullet point\n"
				f.write "#   The entries contain a title and description along with a list of supplementary\n"
				f.write "#   materials (notes, slides, videos, and links)\n"
				f.write "\n"
				f.write "# Notes are supplementary lecture materials, slides are presentations, videos\n"
				f.write "#   are links to video clips, and links are for any other external resources.\n"
				f.write "#   You may always opt to not include one of these sections. You may also opt\n"
				f.write "#   to not include any of the sections and simply have a title and description.\n"
				f.write "\n"
				f.write "# Example:\n"
				f.write "\n"
				f.write "- title: Atomic Bonds\n"
				f.write "  description: A Discussion of several types of bonds among atoms\n"
				f.write "  slides:\n"
				f.write "    - title: Presentation\n"
				f.write "      files: Lecture1.pdf\n"
				f.write "  notes:\n"
				f.write "    - title: Lecture Outline\n"
				f.write "      files: lectures/atomic-bonds.html\n"
				f.write "  links:\n"
				f.write "    - title: Wikipedia article on Covalent Bonds\n"
				f.write "      href: http://en.wikipedia.org/wiki/Covalent_bond\n"
				f.write "    - title: Wikipedia article on Ionic Bonds\n"
				f.write "      href: http://en.wikipedia.org/wiki/Ionic_bond\n"
				f.write "  videos:\n"
				f.write "    - title: Video showing various degrees of covalent bonding\n"
				f.write "      href: http://www.youtube.com/watch?v=1wpDicW_MQQ\n"
				f.write "    - title: Video showing an ionic bond\n"
				f.write "      href: http://www.youtube.com/watch?v=WXyFMJ0eJA0\n"
				f.write "\n"
				f.write "#- title: Next Lecture\n"
				f.write "#  description: Molecules\n"

			end
		end
	end
end

