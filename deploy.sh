#!/bin/sh
ruby build.rb > books.html
cp books.html /home/nonis/Projects/blog/partials/books.html
cd ~/Projects/blog
sudo /home/nonis/Projects/blog/compile.sh
sudo /home/nonis/Projects/blog/deploy.sh
