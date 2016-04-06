require 'singleton'
require 'uri'
require 'net/http'
require 'logger'
require 'csv'

class ServerSyncer
  include Singleton

  def initialize
    @url = URI('http://localhost:3000/movie')
    @local_db_path = '/Users/ben/pro/fantagrabber/movies/list.csv'
    @logger = Logger.new '/var/log/movies.log'
  end

  def sync filenames
    raise 'accept only an array of strings' if filenames.class != Array

    #read the file csv
    films = CSV.read(@local_db_path)

    if !filenames.empty?
      to_sync = []
      filenames.each do |file|
        #check the presence
        doesExist = films.select do |film|
          film.first == file
        end

        #if there, write in the log
        if !doesExist.empty?
          @logger.error "#{file} already exist"
        else
          #otherwise write it and send a request to the API
          CSV.open(@local_db_path, 'a+') do |db|
            @logger.info "#{file} sended to the server"
            db << [file]
            Net::HTTP.post_form(@url, filename: file)
          end
        end
      end
    end

    # must reset the db locally and on the server
    def reset

    end
  end

end