require 'pty'
puts "Beginning scan."

res = []
PTY.spawn 'find /Applications -name "*.app"' do |r,w,p|
  while r.gets.is_a?String do
    res << r.gets

     puts "\r#{res.count} apps found..."
     puts "#{r.gets.rstrip.ljust(80)[0...80]}"
     print "\033[2A"
    
  end
end
print 'done.'

puts "\nDeduping apps..."
apps = []
res.each do |ln|
  item = Hash[:path, ln.strip, :app, "#{ln.split('.app')[0]}.app"]
  apps.push(item)
end

apps = apps.uniq {|item| item[:app]}
#apps.each {|app| puts app[:app]}
puts "Done.  Found #{apps.count} apps in /Applications."