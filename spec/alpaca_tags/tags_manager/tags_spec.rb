require 'spec_helper'

describe AlpacaTags::TagsManager::Tags do
  let(:test_tags) { "#{root}/spec/support/test.tags" }
  let(:root) { File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..')) }

  let(:instance) { AlpacaTags::TagsManager::Tags.new(test_tags) }
  subject { instance }

  describe 'Instance Methods' do
    describe '#reload!' do
      let(:line_length_expected) do
        last_line = 0
        File.open(test_tags,'r') do |file|
          nil while file.gets
          last_line = file.lineno
        end

        last_line
      end

      before do
        subject.reload!
      end

      it { subject.lines.length.should eql(line_length_expected)  }
    end

    describe '#lines' do
      its(:lines) { should be_an_instance_of(Array) }
    end

    describe '#remove_comment!' do
      context 'given only comment line' do
        before do
          File.stub_chain(:open, :read, :split).and_return(['!comment line'])
        end

        its(:remove_comment!) { should eql([]) }
      end

      context 'given uncomment line' do
        let(:line) { %q!Application	/Users/alpaca/project/appli-frontier.com/spec/models/application_spec.rb	/^describe Application do$/;"	d! }
        before do
          File.stub_chain(:open, :read, :split).and_return([line])
        end

        its(:remove_comment!) { subject.lines.first.line.should eql(line) }
      end
    end

    describe '#to_a' do
      its(:to_a) { should be_an_instance_of(Array) }
    end
  end
end
