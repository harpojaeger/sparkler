require 'pty'
termwidth = 80
scanpath = '/Applications/'

puts 'Scanning...'
apps = []

PTY.spawn "find #{scanpath} -name 'Sparkle.framework'" do |r, _w, _p|
  2.times { puts }
  
  while (ln = r.gets).is_a?String
    basepath = ln.split('.app')[0]
    basename = basepath.split(scanpath)[1]

    item = Hash[
    :sparkle, ln.strip,
    :path, "#{basepath}.app",
    :name, "#{basename}.app"
    ]
    apps << item
    print "\033[2A"
    puts "\r#{apps.count} sparkly apps found..."
    puts item[:name].ljust(termwidth)[0...termwidth]

  end
end

print "\033[3A"
puts 'Scanning...done.'.ljust(termwidth)
puts "Found #{apps.count} sparkly apps in #{scanpath}.".ljust(termwidth)
puts ''
