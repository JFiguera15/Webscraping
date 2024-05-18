require "csv"

Character = Struct.new(:name, :element, :path, :rarity)

chars = []
CSV.foreach("output.csv") do |row|
  chars << Character.new(*row)
end

five_stars = chars.select { |c| c.rarity == "5" }
four_stars = chars.select { |c| c.rarity == "4" }

five_star_pity = 0
four_star_pity = 0

repeat = "y"

while repeat == "y" do
  for a in 1..10 do
    if four_star_pity == 10
      current_pull = 95
    elsif five_star_pity >= 75 && five_star_pity < 90
      current_pull = rand(1..106)
    elsif five_star_pity == 90
      current_pull = 100
    else
      current_pull = rand(1..100)
    end
    if current_pull >= 100
      puts("Five star")
      puts("You pulled: #{five_stars[rand(five_stars.length())].name}")
      if (rand(1..2)) == 1
        puts("Won the 50/50")
      else
        puts("Lost")
      end
      five_star_pity = 0
      four_star_pity += 1
    elsif current_pull <= 99 && current_pull >= 94
      puts("Four star")
      puts("You pulled: #{four_stars[rand(four_stars.length())].name}")
      if (rand(1..2)) == 1
        puts("Won the 50/50")
      else
        puts("Lost")
      end
      five_star_pity += 1
      four_star_pity = 0
    else
      puts("Three star")
      five_star_pity += 1
      four_star_pity += 1
    end
  end
  puts("5* pity: #{five_star_pity}")
  puts("4* pity: #{four_star_pity}")
puts("Roll again? (y/n)")
repeat = gets.chomp

end
