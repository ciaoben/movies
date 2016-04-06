require 'csv'
require 'fileutils'

class Movie

  attr_reader :title, :year, :poster_url, :filename, :seen, :overview, :genres
  @@total

  def initialize args
    @title, @year, @poster_url, @filename, @seen, @overview, @genres = nil

    raise 'Take an hash as argument' if args.class != Hash

    args.each do |k,v|
      instance_variable_set "@#{k}", v if instance_variable_defined?("@#{k}")
    end
  end

  def save

    self.instance_values.each do |k,v|
      raise "Missing #{k} parameter" if v.nil?
    end

    CSV.open(Rails.root.to_s + "/db/db.csv", "a+") do |file|
      a = [self.title, self.year, self.poster_url, self.filename, self.seen, self.overview, self.genres]
      file << a
    end

    true
  end

  def self.all
    lines = CSV.read(Rails.root.to_s + "/db/db.csv")
    lines.map do |line|
       Movie.new title: line[0], year: line[1], poster_url: line[2], filename: line[3]
    end
  end

  def self.search title
    jarow = ::FuzzyStringMatch::JaroWinkler.create(:native)
    lines = CSV.read(Rails.root.to_s + "/db/db.csv")
    similar = lines.select do |li|
      jarow.getDistance(title, li[0] ) > 0.80
    end

    # if nothing found try a regex
    if similar.count == 0
      similar = lines.select do |li|
        res = li.join(' ').match Regexp.new("(.*#{title}.*)", Regexp::IGNORECASE)   
      end
    end

    p 'debug---------------------------------------------------------------'
    p similar
    p 'end-----------------------------------------------------------------'

    similar.map do |line|
      Movie.new title: line[0], year: line[1], poster_url: line[2], filename: line[3]
    end

  end

  def self.clear_db
    FileUtils.rm [Rails.root.to_s + "/db/db.csv"]
  end

  # it tries to return the title and the year fo the movie starting
  # from the downloaded filenme
  def self.clean_filename filename
    m = filename.match /^([\w\s]+).*((?:19|20|21)\d\d)*/
    return m[1], m[2]
  end

end
