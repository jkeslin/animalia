class Species < ActiveRecord::Base
  belongs_to :genus
  has_many :cards
  has_one :family, through: :genus
  validates :scientific_name, uniqueness: true

  # REGEXS FOR DOC PARSE/REPLACE
  P_START = /<p>/ # start paragraph tags
  P_END = /<\/p>/ # end paragraph tags
  A_START = /<a href=".*">/ # start link tag
  A_END = /<\/a>/ # end link tag

  def parseWikipedia
    # Works
    # TODO refactor wikipedia parser
    begin
      url = "http://en.wikipedia.org/wiki/#{self.scientific_name.split(" ").join("_")}"
      doc = Nokogiri::HTML(open(url))
      # img_link = doc.search('.infobox img')[0]['src']  # img source
      # intro = (doc.search('p')[0]).to_s # description

      img_link = doc.search('.thumbinner img')[0]['src']
      intro = doc.search('p')[4].text
      intro.gsub!(P_START, '<div class="description">')
      intro.gsub!(P_END, "</div>")
      intro.gsub!(A_START, "<em>")
      intro.gsub!(A_END, "</em>")
      return {intro: intro, img: img_link}
    rescue OpenURI::HTTPError => ex
    end
    begin
      genus_url = "http://en.wikipedia.org/wiki/#{self.scientific_name.split(" ")[0]}"
      doc = Nokogiri::HTML(open(genus_url))
      img_link = doc.search('.infobox img')[0]['src'] # img source
      intro = "<div class='intro'>The #{self.scientific_name} does not have a Wikipedia.org entry.  <a href='#{url}' class='button'>Create one!</a></div>"
      {intro: intro, img: img_link}
    rescue
      img_link = "//upload.wikimedia.org/wikipedia/commons/thumb/6/6b/Bobolink%2C_Mer_Bleue.jpg/800px-Bobolink%2C_Mer_Bleue.jpg"
      return {intro: '', img: img_link}
    end
  end


  def parseRedList
    # Works
    # TODO refactor wikipedia parser
    # begin
      url = "http://www.iucnredlist.org/details/summary/56429/0"
      doc = Nokogiri::HTML(open(url))
      info = doc.search('table')[6].children.text..to_s.gsub("\n", " ")

      # intro = (doc.search('p')[0]).to_s # description
      # intro.gsub!(P_START, '<div class="intro">')
      # intro.gsub!(P_END, "</div>")
      # intro.gsub!(A_START, "<em>")
      # intro.gsub!(A_END, "</em>")
      # return {intro: intro, img: img_link}
    # rescue OpenURI::HTTPError => ex
    # end
    # begin
    #   genus_url = "http://en.wikipedia.org/wiki/#{self.scientific_name.split(" ")[0]}"
    #   doc = Nokogiri::HTML(open(genus_url))
    #   img_link = doc.search('.infobox img')[0]['src'] # img source
    #   intro = "<div class='intro'>The #{self.scientific_name} does not have a Wikipedia.org entry.  <a href='#{url}' class='button'>Create one!</a></div>"
    #   {intro: intro, img: img_link}
    # rescue
    #   img_link = "//upload.wikimedia.org/wikipedia/commons/thumb/6/6b/Bobolink%2C_Mer_Bleue.jpg/800px-Bobolink%2C_Mer_Bleue.jpg"
    #   return {intro: '', img: img_link}
    # end
  end

  def redListStatus
    # TODO convert DB 2 character status code to readable string
    status_hash = { EX: "Extinct", EW: "Extinct in the Wild", CR: "Critically Endangered", EN: "Endangered", VU: "Vulnerable", NT: "Near Threatened", LC: "Least Concern", DD: "Data Deficient" }
    status_hash[self.red_list_status.to_sym]
  end

  def taxonomy
    {
    "kingdom" => "Animalia",
    "phylum" => self.genus.family.order.chlass.phylum.name,
    "class" => self.genus.family.order.chlass.name,
    "order" => self.genus.family.order.name,
    "family" => self.genus.family.name,
    "genus" => self.genus.name
    }
  end

  def parent_name
    "genus"
  end

  def self
    "species"
  end

  def parse_red_list
    begin      
      url = "http://www.iucnredlist.org/details/summary/#{self.red_list_id}/0"

      doc = Nokogiri::HTML(open(url))
      td_array = []

      doc.css('td').each do |el|
        unless el.children.first.nil?
          td_array << el.children.first.content
        end
      end
      
      species_data = {range: "Unknown"}
      td_array.each_with_index do |element, index|  
        case 
          when element =~ /Range Description:/
            species_data[:range] = td_array[index+1].gsub("\n", " ").strip
          when element =~ /Habitat and Ecology:/
            species_data[:habitat] = td_array[index+1].gsub("\n", " ").strip      
          when element =~ /Major Threat/
            species_data[:major_threats] = td_array[index+1].gsub("\n", " ").strip          
        end
      end
      species_data
    rescue OpenURI::HTTPError => ex
      species_data = {range: "Unknown"}
    end
  end

end
