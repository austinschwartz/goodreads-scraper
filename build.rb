require 'goodreads'

$client = Goodreads.new(api_key: "API_KEY_HERE")
$user_id = '16597993'

def print_shelf(shelf_name)
  shelf = $client.shelf($user_id, shelf_name)
  shelf.books[1..10].each do |review|
    link = "<a href='#{review.book.url}'>#{review.book.title}</a>"
    puts "#{review.date_updated[4..9]} #{review.date_updated[26..30]} - #{link}"
  end
end

puts "Currently Reading"
print_shelf('currently-reading')

puts "Last read"
print_shelf('read')
