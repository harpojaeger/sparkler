puts "Scanning..."
#apps = `find /Applications -name "*.app"`
res = []
IO.popen('find /Applications -name "*.app"').each do |line|
  p line.chomp
  res << line.chomp
  puts res.count
end


apps = []
res.each do |ln|
  item = Hash[:path, ln.strip, :app, "#{ln.split('.app')[0]}.app"]
  apps.push(item)
end

apps = apps.uniq {|item| item[:app]}
#apps.each {|app| puts app[:app]}
puts "Found #{apps.count} apps in /Applications."