require 'guard'
require 'guard/guard'

class Guard::PythonUnittest < ::Guard::Guard

  # Initialize a Guard.
  # @param [Array<Guard::Watcher>] watchers the Guard file watchers
  # @param [Hash] options the custom Guard options
  def initialize(watchers = [], options = {})
    watchers << test_file_watcher
    watchers << implementation_file_watcher

    super(watchers, options)
  end

  def start
    run_all
  end

  # Called when just `enter` is pressed
  # This method should be principally used for long action like running all specs/tests/...
  # @raise [:task_has_failed] when run_all has failed
  def run_all
    run_tests_and_report
  end

  # Called on file(s) modifications that the Guard watches.
  # @param [Array<String>] paths the changes files or paths
  # @raise [:task_has_failed] when run_on_change has failed
  def run_on_changes(paths)
    run_tests_and_report(paths)
  end

  protected

    def run_tests_and_report(paths = nil)
      result = run_tests(paths)
      report(result)
    end

    def run_tests(paths)
      if paths
        Array(paths).all? do |path|
          info("#{self.class.name} is now running tests defined in #{path}")
          test_runner.run(path)
        end
      else
        info("#{self.class.name} is now running all tests")
        test_runner.run
      end
    end

    def report(tests_did_pass)
      if tests_did_pass
        ::Guard::Notifier.notify("Passed", :title => "Python Unit Tests", :image => :success, :priority => -2)
      else
        ::Guard::Notifier.notify("Failed", :title => "Python Unit Tests", :image => :failed, :priority => 2)
        throw :task_has_failed
      end
    end

    def test_runner
      @test_runner ||= begin
        main_module_name = File.basename(Dir.pwd).downcase
        TestRunner.new(main_module_name)
      end
    end

  private

    def info(*args, &block)
      ::Guard::UI.info(*args, &block)
    end

    def test_file_watcher
      ::Guard::Watcher.new(%r{^.*/test_.*\.py$})
    end

    def implementation_file_watcher
      ::Guard::Watcher.new(%r{^(.*)/(.*\.py)$}, lambda { |m| m[2] =~ /^test_/ ? nil : "#{m[1]}/test/test_#{m[2]}" } )
    end

end

require 'guard/python_unittest/test_runner'