require 'singleton'

class MetadataParser
  include Singleton

  def initialize
    @token = "126582c1236677d0383cd18eaf3d3506"
    @poster_base_url = "https://image.tmdb.org/t/p/w342"
    Tmdb::Api.key("126582c1236677d0383cd18eaf3d3506")
    Tmdb::Api.language("it")
  end

  def get_metadata title
    m = Tmdb::Movie.find(title)
    return nil if m.count == 0 
    m = Tmdb::Movie.detail(m.first.id)
    {
      overview: m['overview'],
      title: m['title'],
      year: DateTime.parse(m['release_date']).year,
      genres: (m['genres'].map do |g| g['name'] end).join(','),
      poster_url: @poster_base_url + m['poster_path']
    }
  end

end