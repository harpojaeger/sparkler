require 'pty'
termwidth = 80
scanpath = '/Applications'
sparklepath = 'Contents/Frameworks/Sparkle.framework'

puts 'Scanning...'
res = []
2.times { puts }
PTY.spawn "find #{scanpath} -name '*.app'" do |r, _w, _p|
  while (ln = r.gets).is_a?String

    res << ln
    print "\033[2A"
    puts "\r#{res.count} apps found..."
    puts ln.strip.ljust(termwidth)[0...termwidth]

  end
end

print "\033[3A"
puts 'Scanning...done.'.ljust(termwidth)
dedupe_msg = 'Deduping apps...'
print dedupe_msg
apps = []
res.each do |ln|
  item = Hash[
  :path, ln.strip,
  :app, "#{ln.split('.app')[0]}.app",
  :sparkly, false
  ]
  apps << item
end

apps = apps.uniq { |item| item[:app] }
# apps.each {|app| puts app[:app]}
puts 'done.'.ljust(termwidth - dedupe_msg.length)
puts "Found #{apps.count} apps in /Applications.".ljust(termwidth)
print 'Checking for Sparkle.framework...'
apps.each { |app| app[:sparkly] = File.exist?("#{app[:path]}/#{sparklepath}") }
sparkly_apps = apps.select { |app| app[:sparkly] }
puts 'done.'
puts "#{sparkly_apps.count} apps with Sparkle."
