require 'rubygems'
gem 'activesupport', '~> 2.3.10'
gem 'hoe', '>= 2.1.0'
require 'hoe'
require 'fileutils'

require 'active_support/core_ext/time/zones'

require './lib/squiggle'

Hoe.plugin :newgem
# Hoe.plugin :website
# Hoe.plugin :cucumberfeatures

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.spec 'squiggle' do
  self.developer 'Daniel Draper', 'daniel@netfox.com'
  self.post_install_message = 'PostInstall.txt' # TODO remove if post-install message not required
  self.rubyforge_name       = self.name # TODO this is default value
  self.extra_deps           = [['domainatrix'], ['activesupport', "~> 3.0.3"]]
end

require 'newgem/tasks'
Dir['tasks/**/*.rake'].each { |t| load t }

# TODO - want other tests/tasks run by default? Add them to the list
# remove_task :default
# task :default => [:spec, :features]
