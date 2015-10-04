require 'curses'

describe Pepin::InteractiveSearch do
  describe '#search_interactive' do
    let(:searcher) { Pepin::InteractiveSearch.new(%w(aaa aab abb bbb bba baa), view: DummyView) }

    before do
      DummyView.inputs = inputs
    end

    subject { searcher.search }

    context 'b' do
      let(:inputs) { 'b'.each_char }

      it { should == 'aab' }
    end

    context 'ba' do
      let(:inputs) { 'ba'.each_char }

      it { should == 'bba' }
    end

    context 'baa' do
      let(:inputs) { 'baa'.each_char }

      it { should == 'baa' }
    end
  end
end
