class Wikipedia::Main
  def initialize
    Wikipedia.Configure {
      domain 'it.wikipedia.org'
      path   'w/api.php'
    }
  end

  def search_for_original_title ita_title
    eng_title = nil
    variants = create_variants(ita_title).to_enum

    begin
      while !eng_title
        data = Wikipedia.find(variants.next, prop: "revisions", rvprop: "content").raw_data
        if data['query']['pages'].first.first != "-1"
          eng_title = extract_original_title data
        end
      end
      return eng_title
    rescue StopIteration => e
      p "nothing found on wikipedia for #{ita_title}"
      return nil
    end
  end

  private

  def extract_original_title raw_data
    match = raw_data["query"]["pages"].first.last["revisions"].first["*"].match /titolooriginale(\s|=)+\s(.*)/
    match[2]
  end

  # it creates some variants of the title that could help the wikipedia search
  # e.g. Hitch, Hitch (film)...
  def create_variants ita_title
    variants = []
    variants << ita_title.capitalize
    variants << ita_title.capitalize + " (film)"
  end

end
