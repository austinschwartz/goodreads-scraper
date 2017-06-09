require 'goodreads'
require 'set'

$client = Goodreads.new(api_key: "API_KEY_HERE")
$user_id = '16597993'

def get_shelf(shelf_name)
  key = 'date_updated'
  if shelf_name == 'read' then
    key = 'read_at'
  end
  ret = []
  shelf = $client.shelf($user_id, shelf_name)
  (shelf.start..shelf.end).each do |page|
    shelf = $client.shelf($user_id, shelf_name, page: page)
    shelf.books.each do |review|
      link = "<a href='#{review.book.link}'>#{review.book.title}</a>"
      if shelf_name == 'read' then
        if review.key?("read_at") and review.read_at != nil and review.read_at != "" then
          ret << review
        end
      else
        ret << review
      end
    end
  end
  ret.sort_by{|review| DateTime.strptime(review[key], '%a %b %d %H:%M:%S %z %Y')}.reverse
end

def print_shelf(shelf, include_date=FALSE, count=5, favorites_set=Set.new)
  shelf.first(count).each do |review|
    print "<tr>" if include_date
    if include_date then
      new_date = DateTime.strptime(review.read_at, '%a %b %d %H:%M:%S %z %Y')
      print "<td><code style=\"vertical-align:bottom\">#{new_date.strftime('%m/%d/%y')}</code></td>"
    end
    print "<td>" if include_date
    puts "<li>" if !include_date
    print "<i><b>" if favorites_set.include? review.id
    print "<a href=\"#{review.book.link}\">#{review.book.title}</a>"
    print "</b></i>" if favorites_set.include? review.id
    print "</li>" if !include_date
    print "</td></tr>" if include_date
    puts ""
  end
end

favorites_set = get_shelf('favorites').map{|review| review.id}
currently_reading = get_shelf('currently-reading')
read = get_shelf('read')

puts "<div class='post'>"
puts "<h2>Currently Reading</h2>"
puts "<ul>"
print_shelf(currently_reading, include_date=FALSE, count=5, favorites_set=favorites_set)
puts "</ul>"

puts "<h2>Last read</h2>"
puts "<table class='books'>"
print_shelf(read, include_date=TRUE, count=20, favorites_set=favorites_set)
puts "</table>"
puts "</br>"
puts "This list automatically generated from my <a href=\"https://www.goodreads.com/user/show/16597993-austin\">my goodreads account</a> by <a href=\"https://github.com/nonis3/goodreads-scraper\">this script</a>. Books in italics are tagged on goodreads as those I particularly liked."
puts "</div>"

