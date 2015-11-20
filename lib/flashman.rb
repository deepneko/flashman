require "flashman/version"
require "sys/proctable"
include Sys

module Flashman
  def self.init(window, output, interval, speed, times)
    Flashman.new(window, output, interval, speed, times)
  end

  def self.usage
    puts "flashman [-w appname] [-o output-file] [-i interval] [-s speed]"
    puts
    puts "Options are as follows:"
    puts "  -w  Specify an application name which you want to record. The default is 'Terminal'."
    puts "  -o  Specify the output file. The default is to put 'out.gif' in the directory where flashman was executed."
    puts "  -i  Specify the interval in seconds. The screen of the application is recorded every 'interval' seconds."
    puts "  -s  Specify the number of the speed. If you specify '2', the playback speed will be doubled."
    puts "  -t  Specify how many times the output gif loops. The default is '0' which means infinite."
  end

  class Flashman
    def initialize(window, output, interval, speed, times)
      @work_dir = File.join(Dir.home, '.flashman')
      begin
        Dir.mkdir(@work_dir, 0755)
      rescue Errno::EEXIST
        # Do nothing
      end
      @pid_file = "#{@work_dir}/flashman.pid"
      @stop_pid = "#{@work_dir}/flashstop.pid"

      check_macosx
      check_multirun
      optcheck(output, interval, speed, times)

      @windowid = `osascript -e 'tell app \"#{window}\" to id of window 1' 2>/dev/null`.strip
      unless @windowid =~ /^\d+$/
        puts "#{window} isn't the actual application name running on your mac."
        exit 1
      end

      @output = output
      @interval = interval
      @delay = 100 * @interval / speed
      @times = times
      @finish_trap = false
    end

    def run
      begin
        Process.daemon(true, true)
        set_trap
        open(@pid_file, 'w') {|f| f << Process.pid}

        i = 0
        loop do
          break if @finish_trap
          file = "#{@work_dir}/#{i.to_s.rjust(6, "0")}"
          `screencapture -t gif -o -l #{@windowid} #{file}.gif 2>&1 >/dev/null`
          sleep(@interval)
          i += 1
        end
      rescue => e
        STDERR.puts "[ERROR][#{self.class.name}.run] #{e}"
        exit 1
      end

      `gifsicle -O2 --delay=#{@delay} --loopcount=#{@times} #{@work_dir}/*.gif > #{@output} 2>/dev/null`
      File.unlink *Dir.glob("#{@work_dir}/*.png")
      File.unlink *Dir.glob("#{@work_dir}/*.gif")
      File.unlink @pid_file

      if File.exist?(@stop_pid)
        pid = File.open(@stop_pid).first.to_i
        Process.kill("TERM", pid)
      end
    end

    def usage
      puts "flashman [-w appname] [-o output-file] [-i interval] [-s speed] [-t loop-times]"
    end

    def set_trap
      Signal.trap(:TERM) {@finish_trap = true}
    end

    def check_macosx
      os = `uname`
      unless os =~ /^Darwin/
        puts "flashman is only for MacOSX."
        exit 1
      end
    end

    # TODO: There must be any good way to check multirunning.
    def check_multirun
      if File.exist?(@pid_file)
        pid = File.open(@pid_file).first.to_i
        ps = ProcTable.ps(pid)
        if ps.cmdline =~ /flashman\s+/
          puts "flashman has already been running."
          exit 1
        end
      end
    end

    def optcheck(output, interval, speed, times)
      unless output
        usage
        exit 1
      end

      if interval < 0.1 or interval > 10
        usage
        puts "-i option has to be the range between 0.1 and 10."
        exit 1
      end

      if speed < 1 or speed > 10
        usage
        puts "-s option has to be the range between 1 and 10."
        exit 1
      end

      if times < 0
        usage
        puts "-t option has to be 0 or more."
        exit 1
      end
    end
  end
end

