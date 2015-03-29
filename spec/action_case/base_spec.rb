require "spec_helper"

describe ActionCase::Base do

  # Mocks
  # -----

  class NonOverriddenUseCase < ActionCase::Base
  end

  class TestUseCase < ActionCase::Base
    def method_that_succeeds
      respond "some-successful-value"
    end

    def method_that_fails
      respond "some-error-message", false
    end
  end

  module Namespaced
    class TestUseCase < TestUseCase
    end
  end

  class TestListenerWithGenericHandlers
    def method_that_succeeds_success response
    end

    def method_that_fails_error response
    end
  end

  class TestListenerWithExplicitHandlers
    def test_use_case_method_that_succeeds_success response
    end

    def test_use_case_method_that_fails_error response
    end
  end

  class TestListenerWithoutHandlers
  end


  # Tests
  # -----

  context "#initialize" do
    it "sets listener to nil by default" do
      use_case = NonOverriddenUseCase.new
      expect(use_case.listener).to be_nil
    end

    it "sets listener to supplied object" do
      use_case = NonOverriddenUseCase.new(10)
      expect(use_case.listener).to eq 10
    end
  end # initialize

  context "#listener" do
    let(:use_case) { TestUseCase.new }

    describe "when listener provided" do
      describe "contains catch-all handler methods" do
        let(:listener) { TestListenerWithGenericHandlers.new }

        before(:each) do
          use_case.listener = listener
        end

        it "invokes success properly" do
          expect(listener).to receive(:method_that_succeeds_success).with("some-successful-value")
          use_case.method_that_succeeds
        end

        it "invokes error properly" do
          expect(listener).to receive(:method_that_fails_error).with("some-error-message")
          use_case.method_that_fails
        end
      end

      describe "contains explicit handler methods" do
        describe "when use-case not namespaced" do
          let(:listener) { TestListenerWithExplicitHandlers.new }

          before(:each) do
            use_case.listener = listener
          end

          it "invokes success properly" do
            expect(listener).to receive(:test_use_case_method_that_succeeds_success).with("some-successful-value")
            use_case.method_that_succeeds
          end

          it "invokes error properly" do
            expect(listener).to receive(:test_use_case_method_that_fails_error).with("some-error-message")
            use_case.method_that_fails
          end
        end

        describe "when use-case not namespaced" do
          let(:listener) { TestListenerWithExplicitHandlers.new }
          let(:use_case) { Namespaced::TestUseCase.new }

          before(:each) do
            use_case.listener = listener
          end

          it "invokes success properly" do
            expect(listener).to receive(:test_use_case_method_that_succeeds_success).with("some-successful-value")
            use_case.method_that_succeeds
          end

          it "invokes error properly" do
            expect(listener).to receive(:test_use_case_method_that_fails_error).with("some-error-message")
            use_case.method_that_fails
          end
        end
      end

      describe "hasn't supplied handler methods" do
        it "returns immediate result" do
          use_case.listener = TestListenerWithoutHandlers.new
          expect(use_case.method_that_succeeds).to eq "some-successful-value"
          expect(use_case.method_that_fails).to eq "some-error-message"
        end
      end
    end

    describe "when listener nil" do
      it "returns immediate result" do
        expect(use_case.method_that_succeeds).to eq "some-successful-value"
        expect(use_case.method_that_fails).to eq "some-error-message"
      end
    end
  end # listener

  context "#resource" do
    it "when not overridden it raises an exception" do
      use_case = NonOverriddenUseCase.new
      expect{ use_case.resource }.to raise_error
    end
  end # resource

end
