module Debuggers
  module Benchmark
    def self.included(klass)
      klass.extend ClassMethods
    end

    module ClassMethods
      def benchmark_on(*method_names)
        return unless ENV['DEBUG']

        unless const_defined?(:BenchmarkMethods)
          const_set(:BenchmarkMethods, Module.new)
        end

        method_names.each do |method_name|
          build_benchmark_methods(to_s, method_name)

          prepend self::BenchmarkMethods
        end
      end

      private

      def build_benchmark_methods(class_name, method_name)
        self::BenchmarkMethods.class_eval <<-CODE, __FILE__, __LINE__ + 1
          def #{method_name}(*args)
            puts "#{class_name}##{method_name} STARTED"

            orig_method = nil

            time = ::Benchmark.realtime do
              orig_method = super(*args)
            end

            puts "#{class_name}##{method_name} FINISHED in %.6f" % time

            orig_method
          end
        CODE
      end
    end
  end
end
