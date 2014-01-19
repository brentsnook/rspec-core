require "rspec/support/warnings"

module RSpec

  # @private
  #
  # Used internally to print deprecation warnings
  def self.deprecate(deprecated, data = {})
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
  def self.warn_deprecation(message)
    RSpec.configuration.reporter.deprecation :message => message
  end

  @orig_warn_with = method(:warn_with)

  def self.warn_with(message, options = {})
    if options.fetch(:call_site, :not_present).nil?
      message << " Warning generated from spec at `#{RSpec.current_example.source_location.join(":")}`."
    end

    @orig_warn_with.call(message, options)
  end
end
