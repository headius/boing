require "boing/version"
require 'fileutils'

class Boing
  INPROC_RAILS_CMDS = %w[c console r runner g generate d destroy]

  def initialize(args)
    @args = args.dup
  end

  def run
    # warn if we're not in drip; and if not, load dripmain.rb as well
    if ENV['DRIP_INIT_CLASS'] == nil
      $stderr.puts "Note: Not running in drip; may be booting or configured wrong"
      dripmain = File.join(Dir.pwd, 'dripmain.rb')
      if File.exist?(dripmain)
	load dripmain
      end
    end

    # check for known "special" commands
    if @args[0] == 'rails' && INPROC_RAILS_COMMANDS.include?(@args[1])
      # running a `rails` command

      # best value comes from prebooting rails, so warn if not prebooted
      if !defined?(Rails)
	$stderr.puts "Note: Running Rails commands but Rails is not prebooted."
	require File.join(Dir.pwd, 'config/application.rb')
      end

      # commands that just reboot rails can run in-process
      @args.shift
      Object.const_set(:APP_PATH, ::Rails.root.join("config/application"))
      require "rails/commands"
      exit

    elsif @args[0] == 'killall'
      # kill all drip instances
      $stderr.puts "Killing all drip instances"
      system "drip kill"
      exit

    elsif @args[0] == 'dripmain'
      # Install a basic dripmain.rb for Rails use
      if !File.exist? File.expand_path('./config/application.rb')
	$stderr.puts "#{Dir.pwd} does not appear to be a rails application."
	exit
      end
      if File.exist? 'dripmain.rb'
	FileUtils.cp 'dripmain.rb', 'dripmain.rb.bak'
      end
      File.open('dripmain.rb', 'w') do |f|
	f.puts("require File.expand_path('../config/application', __FILE__)")
      end
      exit
    end

    # All other commands run as is
    cmd = @args.shift
    load File.join(File.dirname(Gem.ruby), cmd)
  end
end
