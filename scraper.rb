require "httparty"
require "nokogiri"
require "parallel"
require "csv"

# defining a data structure to store the scraped data
Character = Struct.new(:name, :element, :path)

# initializing the list of objects
# that will contain the scraped data
characters = []

# initializing a semaphore

	# retrieving the current page to scrape
	response = HTTParty.get("https://starrailstation.com/en/characters", {
		headers: {
			"User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36"
		},
	})

	# parsing the HTML document returned by server
	document = Nokogiri::HTML(response.body)

	# selecting all HTML product elements
	html_products = document.css("a.a7916")

	# iterating over the list of HTML products
	html_products.each do |html_product|
		# extracting the data of interest
		# from the current product HTML element
		name = html_product.css("div.ellipsis").first.text
		element = html_product.css("img.abb3e").first.attribute("alt").value
    path = html_product.css("img.a4e84").first.attribute("alt").value

		# storing the scraped data in a PokemonProduct object
		character = Character.new(name, element, path)

		# adding the PokemonProduct to the list of scraped objects
		characters.push(character)
	end

# defining the header row of the CSV file
csv_headers = ["name", "path", "element"]
CSV.open("output.csv", "wb", write_headers: true, headers: csv_headers) do |csv|
	characters.each do |character|
		csv << character
	end
end
