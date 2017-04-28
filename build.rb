require 'goodreads'

$client = Goodreads.new(api_key: "API_KEY_HERE")
$user_id = '16597993'

def print_shelf(shelf_name)
  shelf = $client.shelf($user_id, shelf_name)
  shelf.books[1..10].each do |review|
    link = "<a href='#{review.book.link}'>#{review.book.title}</a>"
    puts "<li>"
    puts "<b>#{review.date_updated[4..9]} #{review.date_updated[26..30]}</b> - #{link}"
    puts "</li>"
  end
end

puts "<div class='post'>"
puts "<h2>Currently Reading</h2>"
puts "<ul style='list-style:none'>"
print_shelf('currently-reading')
puts "</ul>"

puts "<h2>Last read</h2>"
puts "<ul style='list-style:none'>"
print_shelf('read')
puts "</ul>"
puts "</div>"
