require 'irb/ext/save-history'
require 'rubygems'
require 'pp'
require 'pathname'
require 'fileutils'

begin
  require 'ap'
rescue LoadError
end

begin
  require 'bond'
  Bond.start
rescue LoadError
  require 'irb/completion'
end

if RUBY_VERSION < "1.9"
  begin
    require 'wirble'
    Wirble.init
    Wirble.colorize
  rescue LoadError
  end
  
  begin
    require 'utility_belt'
  rescue LoadError
  end
  
  begin
    require 'sketches'
    Sketches.config :editor => 'mate'
  rescue LoadError
  end
  # require 'facets/yaml'
  # require 'parse_tree'
  # require 'parse_tree_extensions'
  # require 'ruby2ruby'
end

IRB.conf[:USE_READLINE] = true
IRB.conf[:SAVE_HISTORY] = 2500
IRB.conf[:PROMPT_MODE] = :DEFAULT

include FileUtils::Verbose

def path(path_str)
  Pathname.new(path_str.to_s)
end

def glob(*args)
  if block_given?
    Dir.glob(*args) {|f| yield Pathname.new(f) }
  else
    Dir.glob(*args).map {|f| Pathname.new(f) }
  end
end

def home
  Pathname.home
end
def root
  Pathname.root
end
def work
  Pathname.work
end
def pwd
  Pathname.new(FileUtils.pwd)
end

class Object
  def local_methods
    (methods - Object.instance_methods).sort
  end
  def local_instance_methods
    (self.class.instance_methods - Object.instance_methods).sort
  end
end

if RUBY_VERSION < "1.9"
  module Kernel
    # which { some_object.some_method() } => ::
    def where_is_this_defined(settings={}, &block)
      settings[:debug] ||= false
      settings[:educated_guess] ||= false

      events = []

      set_trace_func lambda { |event, file, line, id, binding, classname|
        events << { :event => event, :file => file, :line => line, :id => id, :binding => binding, :classname => classname }

        if settings[:debug]
          puts "event => #{event}" 
          puts "file => #{file}" 
          puts "line => #{line}" 
          puts "id => #{id}" 
          puts "binding => #{binding}" 
          puts "classname => #{classname}" 
          puts ''
        end
      }
      yield
      set_trace_func(nil)

      events.each do |event|
        next unless event[:event] == 'call' or (event[:event] == 'return' and event[:classname].included_modules.include?(ActiveRecord::Associations))
        return "#{event[:classname]} received message '#{event[:id]}', Line \##{event[:line]} of #{event[:file]}" 
      end

      # def self.crazy_custom_finder
      #  return find(:all......)
      # end
      # return unless event == 'call' or (event == 'return' and classname.included_modules.include?(ActiveRecord::Associations))
      # which_file = "Line \##{line} of #{file}" 
      if settings[:educated_guess] and events.size > 3
        event = events[-3]
        return "#{event[:classname]} received message '#{event[:id]}', Line \##{event[:line]} of #{event[:file]}" 
      end

      return 'Unable to determine where method was defined.'
    end
  end

  # Just for Rails...
  if rails_env = ENV['RAILS_ENV']
    require 'logger'
    rails_root = File.basename(Dir.pwd)
    # require 'hirb'
    # Hirb.enable
    IRB.conf[:PROMPT] ||= {}
    # IRB.conf[:PROMPT][:RAILS] = {
    #   :PROMPT_I => "#{Wirble::Colorize.colorize_string(rails_root, :cyan)}#{Wirble::Colorize.colorize_string("(#{rails_env})", :light_red)}:%03n:%i#{Wirble::Colorize.colorize_string('>', :white)} ",
    #   :PROMPT_S => "#{Wirble::Colorize.colorize_string(rails_root, :cyan)}#{Wirble::Colorize.colorize_string("(#{rails_env})", :light_red)}:%03n:%i#{Wirble::Colorize.colorize_string('%l', :white)}",
    #   :PROMPT_C => "#{Wirble::Colorize.colorize_string(rails_root, :cyan)}#{Wirble::Colorize.colorize_string("(#{rails_env})", :light_red)}:%03n:%i#{Wirble::Colorize.colorize_string('?', :white)} ",
    #   :PROMPT_N => "#{Wirble::Colorize.colorize_string(rails_root, :cyan)}#{Wirble::Colorize.colorize_string("(#{rails_env})", :light_red)}:%03n:%i#{Wirble::Colorize.colorize_string('>', :white)} ",
    #   :RETURN   => " => %s\n" 
    # }
    IRB.conf[:PROMPT][:RAILS] = {
      :PROMPT_I => "#{rails_root}(#{rails_env}):%03n:%i> ",
      :PROMPT_S => "#{rails_root}(#{rails_env}):%03n:%i%l ",
      :PROMPT_C => "#{rails_root}(#{rails_env}):%03n:%i? ",
      :PROMPT_N => "#{rails_root}(#{rails_env}):%03n:%i> ",
      :RETURN   => " => %s\n" 
    }
    IRB.conf[:PROMPT_MODE] = :RAILS
    RAILS_DEFAULT_LOGGER = Logger.new(STDOUT)

    # IRB.conf[:IRB_RC] = Proc.new do
    #   # Called after the irb session is initialized and Rails has
    #   # been loaded (props: Mike Clark).
    #   if defined? ActiveRecord::Base
    #     ActiveRecord::Base.logger = RAILS_DEFAULT_LOGGER
    #   end
    #   
    #   if defined?(ActionController::UrlWriter)
    #     include ActionController::UrlWriter
    #   end
    # end
  end
end
