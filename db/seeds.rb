posts = [
    ["Merhaba 1", "Bu deneme açıklaması 1\n\nBu ikinci paragraf!"],
    ["Merhaba 2", "Bu **deneme** açıklaması 2"]
]
puts "Deleting all records..."
Post.delete_all

posts.each do |title, description|
  puts "Creating: - #{title} -"
  Post.create(title: title, description: description)
end

puts "How many records are available? #{Post.all.count}"