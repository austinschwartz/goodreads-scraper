require 'goodreads'

$client = Goodreads.new(api_key: "API_KEY_HERE")
$user_id = '16597993'

def get_shelf(shelf_name)
  ret = []
  shelf = $client.shelf($user_id, shelf_name)
  key = 'date_updated'
  if shelf_name == 'read' then
    key = 'read_at'
  end
  shelf.books[1..10].each do |review|
    link = "<a href='#{review.book.link}'>#{review.book.title}</a>"
    if shelf_name == 'read' then
      if review.key?("read_at") and review.read_at != nil and review.read_at != "" then
        ret << review
      end
    else
      ret << review
    end
  end
  ret.sort_by{|review| DateTime.strptime(review[key], '%a %b %d %H:%M:%S %z %Y')}.reverse
end

def print_shelf(shelf,include_date=FALSE)
  shelf.first(5).each do |review|
    print "<li>"
    if include_date then
      print "<b>#{review.date_updated[4..9]} #{review.date_updated[26..30]}</b> - "
    end
    print "<a href=\"#{review.book.link}\">#{review.book.title}</a>"
    print "</li>"
    puts ""
  end
end

currently_reading = get_shelf('currently-reading')
read = get_shelf('read')

puts "<div class='post'>"
puts "<h2>Currently Reading</h2>"
puts "<ul style='list-style:none'>"
print_shelf(currently_reading)
puts "</ul>"

puts "<h2>Last read</h2>"
puts "<ul style='list-style:none'>"
print_shelf(read, TRUE)
puts "</ul>"
puts "</div>"
