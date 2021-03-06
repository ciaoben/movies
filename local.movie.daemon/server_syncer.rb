require 'singleton'
require 'uri'
require 'net/http'
require 'logger'
require 'csv'

class ServerSyncer
  include Singleton

  def initialize
    @url = URI('http://sportasy.it:9292/movie')
    @local_db_path = '/usr/local/bin/local.movie.daemon/list.csv'
    @logger = Logger.new '/var/log/movies.log'
  end

  def sync filenames
    raise 'accept only an array of strings' if filenames.class != Array
    # value to return to indicate if something has been sended to the server
    # or not
    has_synced = false
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
          has_synced = true
          #ot herwise write it and send a request to the API
          CSV.open(@local_db_path, 'a+') do |db|
            @logger.info "#{file} sended to the server"
            db << [file]
            Net::HTTP.post_form(@url, filename: file)
          end
        end
      end
      return has_synced
    end

    # must reset the db locally and on the server
    def reset

    end
  end

end