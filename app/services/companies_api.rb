class CompaniesApi
  def self.getcompanies
    url = "https://avoindata.prh.fi/opendata-ytj-api/v3/companies?mainBusinessLine=11050"

    response = HTTParty.get url

    parsed = response.parsed_response
    target = []
    parsed["companies"].each do |i|
      i["names"].each do |j|
        target << { "name" => j["name"], "year" => j["registrationDate"].split('-')[0] }
      end
    end

    target.map{ |i| [i["name"], i["year"]] }
  end
end
