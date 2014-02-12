require "spec_helper"

RSpec.describe "rspec warnings and deprecations" do

  describe "#deprecate" do
    it "passes the hash to the reporter" do
      expect(RSpec.configuration.reporter).to receive(:deprecation).with(hash_including :deprecated => "deprecated_method", :replacement => "replacement")
      RSpec.deprecate("deprecated_method", :replacement => "replacement")
    end

    it "adds the call site" do
      expect_deprecation_with_call_site(__FILE__, __LINE__ + 1)
      RSpec.deprecate("deprecated_method")
    end

    it "doesn't override a passed call site" do
      expect_deprecation_with_call_site("some_file.rb", 17)
      RSpec.deprecate("deprecated_method", :call_site => "/some_file.rb:17")
    end
  end

  describe "#warn_deprecation" do
    it "puts message in a hash" do
      expect(RSpec.configuration.reporter).to receive(:deprecation).with(hash_including :message => "this is the message")
      RSpec.warn_deprecation("this is the message")
    end
  end

  describe "#warn_with" do
    context "explicit nil call site" do

      let(:options) { { :call_site => nil } }

      it "adds the source location of spec" do
        line = __LINE__ - 1
        expect(Kernel).to receive(:warn).with("The warning. Warning generated from spec at `#{__FILE__}:#{line}`.")

        RSpec.warn_with("The warning.", options)
      end

      context "when there is no current example" do
        before do
          allow(RSpec).to receive(:current_example).and_return(nil)
        end

        it "Tells the user it was unable to determine the cause of the warning" do
          expect(Kernel).to receive(:warn).with("The warning. RSpec could not determine which call generated this warning.")

          RSpec.warn_with("The warning.", options)
        end
      end
    end
  end
end
