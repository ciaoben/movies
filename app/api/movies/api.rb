class Movies::API < Grape::API

  format :json

  desc 'List and filter movies'
  params do
    optional :search, type: String
  end

  get :index do
    if params[:search]
      m = Movie.search params[:search]
    else
      m = Movie.all
    end
    error! :not_found, 404 if m.count == 0
    m
  end

  desc 'Add movie parsed from the agent'
  params do
    requires :filename, type: String, desc: 'nameofthefile'
  end
  post 'movie' do
    t = TitleParser.instance
    m = MetadataParser.instance
    mo = t.guessit declared(params)[:filename]
    metadata = m.get_metadata mo
    metadata.merge! filename: declared(params)[:filename], seen: false
    m = Movie.new metadata
    body false if m.save
  end

  desc 'Add a movie parsed from the agent, OLD PROCEDURE'
  params do
    requires :filename, type: String, desc: 'nameofthefile'
    #optional :color, type: String, default: 'blue', values: ['red', 'green']
  end

  post 'old/movie' do
    # MUST CLEAN FROM SPECIAL CHARS
    wiki = Wikipedia::Main.new
    title = wiki.search_for_original_title declared(params)[:filename]
    title = declared(params)[:filename] if title.nil?
    title, year = Movie.clean_filename title
    movie_id = Imdb::Search.new("#{title} #{year}").movies.first.id
    movie = Imdb::Movie.new(movie_id)
    m = Movie.new title: movie.title,
                  poster_url: movie.poster,
                  year: movie.year,
                  filename: declared(params)[:filename]
    body false if m.save
  end

end
