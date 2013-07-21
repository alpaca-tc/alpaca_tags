require 'spec_helper'

describe AlpacaTags::Cacher::Vim do
  let(:default_directory) { '/tmp' }
  let(:instance) { AlpacaTags::Cacher::Vim.new(default_directory) }
  subject { instance }

  describe 'Instance Methods' do
    let(:data) { { 'name' => 'test', 'value' => 'value' } }
    let(:name) { 'name' }
    let(:file_path) { instance.send(:file_path, name) }

    describe '#write' do
      subject { instance.write(name, data) }

      it { should be_true }
      it 'writes data as caching' do
        File.exist?(file_path).should be_true
        JSON.parse(File.open(file_path).read).should eql(data)
      end
    end

    describe '#read' do
      before do
        instance.write(name, data)
      end

      subject { instance.read(name) }

      it 'reads data as caching' do
        should eql(data)
      end
    end
  end
end
