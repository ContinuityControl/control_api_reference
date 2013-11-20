desc 'Release public app and documentation'
task :release do
  system 'git checkout master'
  system 'git push origin master'
  system 'git push heroku master'

  # FIXME: this command is specific to @benjaminoakes' machine
  system '~/node_modules/docco/bin/docco app.rb'
  system 'git checkout gh-pages'
  system 'mv docs/app.html index.html'
  system 'rm -rf docs'
  system 'git commit -a -m "[rake] rake release"'
  system 'git push origin gh-pages'

  system 'git checkout master'
end
