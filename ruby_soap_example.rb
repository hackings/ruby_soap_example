begin
  require 'savon'

  class ZipCode

    attr_reader :zip, :client, :state, :city, :area_code, :time_zone

    def initialize(zip)
      @zip = zip
      @client = Savon::Client.new do | wsdl, http, wsse |
        wsdl.document = "http://www.webservicex.net/uszip.asmx?WSDL"
        #http.proxy = "http://proxy.webservicex.net/uszip.asmx?WSDL" #TODO proxy set up
        #wsse.credentials "username", "password"                     #TODO username, password credential 
      end
    end

    def get_location
      response = client.request :web, :get_info_by_zip, body: { "USZip" => zip }
      if response.success?
        data = response.to_array(:get_info_by_zip_response, :get_info_by_zip_result, :new_data_set, :table).first
        if data
          @state = data[:state]
          @city = data[:city]
          @area_code = data[:area_code]
          @time_zone = data[:time_zone]
        end
      end
    end

  end

  zip_code = ZipCode.new("90210")
  zip_code.get_location

  puts '-------------------'
  puts zip_code.state
  puts zip_code.city
  puts zip_code.area_code
  puts zip_code.time_zone
  puts "-------------------"

rescue LoadError => e
  puts "install gem savon. 'gem install savon -v='0.9.7''"  
end

