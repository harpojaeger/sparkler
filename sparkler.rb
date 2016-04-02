require 'pty'
puts 'Starting scan.'

res = []

PTY.spawn 'find /Applications -name "*.app"' do |r, _w, _p|
  puts ''
  puts ''

  while (ln = r.gets).is_a?String

    res << ln
    print "\033[2A"
    puts "\r#{res.count} apps found..."
    puts (ln.strip.ljust(80)[0...80])

    end
end

print "\033[1A"
puts 'Done.'.ljust(80)
puts 'Deduping apps...'
apps = []
res.each do |ln|
  item = Hash[:path, ln.strip, :app, "#{ln.split('.app')[0]}.app"]
  apps << item
end

apps = apps.uniq { |item| item[:app] }
# apps.each {|app| puts app[:app]}
puts "Done.  Found #{apps.count} apps in /Applications."
