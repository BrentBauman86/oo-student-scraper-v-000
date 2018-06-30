require_relative "../lib/scraper.rb"
require_relative "../lib/student.rb"
require 'nokogiri'
require 'colorize'

class CommandLineInteface
  BASE_PATH = "./fixtures/student-site/"

  def run
    make_students
    add_attributes_to_students
    display_students
  end

  def make_students
    students_array = Scraper.scrape_index_page(BASE_PATH + 'index.html')
    Student.create_from_collection(students_array)
  end

  def add_attributes_to_students
    Student.all.each do |student|
      attributes = Scraper.scrape_profile_page(BASE_PATH + student.profile_url)
      student.add_student_attributes(attributes)
    end
  end

  def self.brew_scraper
    doc = Nokogiri::HTML(open("https://untappd.com"))
    binding.pry
    brews = []
    doc.css("div.result-list.beer-list").each do |list|
      list.css("div.content").each do |content|
      name = content.css("div.name").text
      abv = content.css("p.abv").text
      brewery = content.css("p.brewery").text
      brews << {:name => name, :brewery => brewery, :abv => abv}
      binding.pry
    # this needs to return our array of brews!!
        end
        # profile_url = "#{link.attr("href")}"
      end
    end


  def display_students
    Student.all.each do |student
      puts "#{student.name.upcase}".colorize(:blue)
      puts "  location:".colorize(:light_blue) + " #{student.location}"
      puts "  profile quote:".colorize(:light_blue) + " #{student.profile_quote}"
      puts "  bio:".colorize(:light_blue) + " #{student.bio}"
      puts "  twitter:".colorize(:light_blue) + " #{student.twitter}"
      puts "  linkedin:".colorize(:light_blue) + " #{student.linkedin}"
      puts "  github:".colorize(:light_blue) + " #{student.github}"
      puts "  blog:".colorize(:light_blue) + " #{student.blog}"
      puts "----------------------".colorize(:green)
    end
  end

end
