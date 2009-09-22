require File.join(File.dirname(__FILE__), 'spec_helper')

describe SimplyTabby do
  describe :release_file do
    after(:each) do
      Object.send(:remove_const, 'SimplyTabby')
      load File.join(File.dirname(__FILE__), '..', 'lib', 'simply_tabby.rb')
    end

    it "returns the overriden release file" do
      SimplyTabby.settings = {:release_file => :foo}

      SimplyTabby.release_file.should == :foo
    end

    it "returns the default release file" do
      Rails.stub!(:root).and_return('/rails_root')

      SimplyTabby.release_file.should == '/rails_root/VERSION'
    end
  end

  describe :release_metadata do
    describe :file_exists do
      before(:each) do
        File.should_receive(:exist?).and_return(true)
      end

      it "returns a YAML reference to release_file" do
        SimplyTabby.should_receive(:release_file).twice.and_return(:release_file)
        File.should_receive(:read).with(:release_file).and_return('foo: bar')

        SimplyTabby.release_metadata.should == {"foo" => "bar"}
      end

      it "returns empty hash when File#read fails" do
        File.should_receive(:read).and_raise(Errno::ENOENT)

        SimplyTabby.release_metadata.should == {}
      end
    end

    it "returns empty hash when missing release_file" do
      SimplyTabby.release_metadata.should == {}
    end
  end

  describe :data do
    after(:each) do
      Object.send(:remove_const, 'SimplyTabby')
      load File.join(File.dirname(__FILE__), '..', 'lib', 'simply_tabby.rb')
    end

    it "returns environment" do
      Rails.stub!(:env).and_return(:environment)

      SimplyTabby.data[:environment].should == :environment
    end

    it "returns obfuscated hostname" do
      Socket.stub!(:gethostname).and_return('ab01.cd1.domain.com')

      SimplyTabby.data[:hostname].should == 'a01cd'
    end

    it "returns hostname when hostname doesn't match obfuscation" do
      Socket.stub!(:gethostname).and_return('hostname.domain.com')

      SimplyTabby.data[:hostname].should == 'hostname.domain.com'
    end

    it "returns default data" do
      keys = SimplyTabby.data.dup
      keys.delete(:environment)
      keys.delete(:hostname)

      keys.should be_empty
    end

    it "merges on additional keys" do
      SimplyTabby.should_receive(:release_metadata).and_return(:foo => :bar, :baz => :xyzzy)
      keys = SimplyTabby.data

      keys[:foo].should == :bar
      keys[:baz].should == :xyzzy
    end
  end

  describe :do_tell do
    it "surrounds with comments" do
      tabby = SimplyTabby.do_tell.split("\n")

      tabby[0].should  == '<!-- SimplyTabby'
      tabby[-1].should == '-->'
    end

    it "doesn't surround with comments" do
      tabby = SimplyTabby.do_tell(:no_comment => true).split("\n")

      tabby.should_not == /--/
    end
  end
end
