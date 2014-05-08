require 'sane/version'

module Sane
  def sanitize(path, fn, &block)
    return unless block
    file_list = fn.call(path)
    (file_list.map { |file| block.call(file) }).all?
  end

  module_function :sanitize

  class Inspector
    attr_accessor :reporter, :sub_inspectors

    def initialize(sub_inspectors = [], reporter = Sane::Reporter.new)
      @reporter = reporter
      @sub_inspectors = sub_inspectors
    end

    def checker
      lambda do |file|
        @sub_inspectors.each do |sub_inspector|
          begin
            sub_inspector.checker.call file
          rescue Exception => e
            @reporter.results[file] = @reporter.results[file] || [];
            @reporter.results[file] << e.message
            break
          end
        end
      end
    end
  end

  class Reporter
    attr_accessor :results

    def initialize
      @results = {}
    end
  end

  module SubInspectors
    class FileValidInspector
      def checker
        lambda do |file|
          raise('File Not existent') unless (File.new(file).lstat.size != 0)
        end
      end
    end

    class FileExistsInspector
      def checker
        lambda do |file|
          raise('File Not Found') unless File.exists? file
        end
      end
    end
  end
end
