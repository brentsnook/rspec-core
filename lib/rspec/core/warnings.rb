require "rspec/support/warnings"

module RSpec
  module Core
    module Warnings
      # @private
      #
      # Used internally to print deprecation warnings
      def deprecate(deprecated, data = {})
        RSpec.configuration.reporter.deprecation(
          {
            :deprecated => deprecated,
            :call_site => CallerFilter.first_non_rspec_line
          }.merge(data)
        )
      end

      # @private
      #
      # Used internally to print deprecation warnings
      def warn_deprecation(message)
        RSpec.configuration.reporter.deprecation :message => message
      end

      def warn_with(message, options = {})
        if options.fetch(:spec_location, false)
          if message.chars.to_a.last != "."
            message = message + "."
          end

          if RSpec.current_example.nil?
            message << " RSpec could not determine which call generated this warning."
          else
            message << " Warning generated from spec at `#{RSpec.current_example.location}`."
          end
        end

        super(message, options)
      end
    end
  end
end
