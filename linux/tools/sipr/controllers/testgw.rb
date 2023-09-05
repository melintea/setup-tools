
puts "#{ENV['SIPPER_HOME']}"
$:.unshift File.join(ENV['SIPPER_HOME'],'sipper')
$:.unshift File.join(ENV['SIPPER_HOME'],'sipper_test')
require 'sipper_configurator'

require 'sipper'
require 'monitor'

$ULOGNAME = File.basename($0)[0...-3]
puts "ULOG=#{$ULOGNAME}"
puts "Config=#{SipperConfigurator}"
puts "Config[:ControllerPath]=#{SipperConfigurator[:ControllerPath]}"

$:.unshift SipperConfigurator[:ControllerPath]

Thread.current[:name] = "MainGWThread"
s = SIP::Sipper.new() 
t = s.start 

puts "Transports=#{SIP::Locator[:Tm].transports}"
puts "Controllers size=#{SIP::Locator[:Cs].get_controllers.size}"
SIP::Locator[:Cs].get_controllers.each_with_index do |c, i|
    puts "Controller[#{i}]==#{c}"
end
puts "Done Controllers"
Signal.trap("INT") { puts; s.stop; exit }
loop do 
  t.join(3)
  exit if s.exit_now
  Signal.trap("INT") { puts; s.stop; exit }
end

