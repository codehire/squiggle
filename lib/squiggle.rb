$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'active_support/core_ext/time/conversions'
require 'active_support/core_ext/time/zones'

require 'squiggle/base'
require 'squiggle/chunk_parser'
require 'squiggle/domain_parser'
require 'squiggle/log_line'
require 'squiggle/squid_standard_parser'

module Squiggle
  VERSION = '0.0.2'
end
