require 'pathname'

class Guard::PythonUnittest::TestRunner
  attr_reader :directory

  def initialize(directory)
    @directory = directory
  end

  def run(path = nil)
    if path
      execute(convert_path_to_module_name(path))
    else
      execute
    end
  end

  private

    def command
      "python"
    end

    def command_line_arguments(*args)
      ["-m", "unittest", *args]
    end

    def execute(module_name = "discover")
      Dir.chdir(directory) { system(command, *command_line_arguments(module_name)) }
    end

    def convert_path_to_module_name(path)
      relative_path = Pathname(path).relative_path_from(Pathname(directory)).to_s
      relative_path.chomp!(File.extname(path)).gsub!('/', '.')
    end

end