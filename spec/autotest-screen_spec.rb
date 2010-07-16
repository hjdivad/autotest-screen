require 'spec_helper'

describe "autotest-screen" do
  before do
    @autotest = Autotest.new
    @autotest.hook( :updated )
  end

  describe "handling results" do

    describe "for RSpec" do
      it "should show a 'passed' notification" do
        Autotest::Screen.should_receive( :screen_caption= ).with(
          "%{dG} 10 examples passed."
        )
        @autotest.results = [ "10 examples, 0 failures" ]
        @autotest.hook( :ran_command )
      end

      it "should show a 'failed' notification" do
        Autotest::Screen.should_receive( :screen_caption= ).with(
          "%{dR} 1 failed from 10."
        )
        @autotest.results = [ "10 examples, 1 failures" ]
        @autotest.hook( :ran_command )
      end

      it "should show a 'pending' notification" do
        Autotest::Screen.should_receive( :screen_caption= ).with(
          "%{dy} 1 pending from 10."
        )
        @autotest.results = [ "10 examples, 0 failures, 1 pending" ]
        @autotest.hook( :ran_command )
      end

      it "should show an 'error' notification" do
        Autotest::Screen.should_receive( :screen_caption= ).with(
          "%{dR} Error running tests."
        )
        @autotest.results = []
        @autotest.hook( :ran_command )
      end
    end
  end

  describe "handling autotest exit" do
    it "should clear the screen caption on quitting" do
      Autotest::Screen.should_receive( :clear_screen_caption )
      @autotest.hook( :quit )
    end

    it "should clear the screen caption on error" do
      Autotest::Screen.should_receive( :clear_screen_caption )
      @autotest.hook( :died )
    end
  end
end
