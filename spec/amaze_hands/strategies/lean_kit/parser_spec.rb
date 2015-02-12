describe Strategies::LeanKit::Parser do
  let(:fixture) { Fixture.read('lean_kit/P-217.txt') }
  let(:ast)     { Strategies::LeanKit::Parser.new.parse(fixture) }

  subject(:actions_ast) { ast.select { |node| node[:action] } }

  its(:length) { is_expected.to eq(55) }

  describe 'actions' do
    describe 'P-217 [C] Discard "draft" prices' do
      subject { ast.detect { |node| node[:card_number] } }

      its([:card_number]) { is_expected.to eq('P-217') }
      its([:title])       { is_expected.to eq(%q{[C] Discard 'draft' prices}) }
    end

    describe '02/10/2015 at 01:34:57 PM - Fred Wu moved this Card from BAT to Done' do
      subject { actions_ast.detect { |node| node[:action][:timestamp][:time] == '01:34:57 PM' } }

      it 'from' do
        expect(subject[:action][:description][0][:from]).to eq('BAT')
      end

      it 'to' do
        expect(subject[:action][:description][0][:to]).to eq('Done')
      end
    end

    describe '02/10/2015 at 01:34:39 PM - Fred Wu changed this Card: Class of Service: from "Expedite" to ""' do
      subject { actions_ast.detect { |node| node[:action][:timestamp][:time] == '01:34:39 PM' } }

      it 'service_from' do
        expect(subject[:action][:description][0][:service_from]).to eq('Expedite')
      end

      it 'service_to' do
        expect(subject[:action][:description][0][:service_to]).to be_nil
      end
    end

    describe '02/09/2015 at 06:32:25 PM - Xi Chen changed this Card: Class of Service: from <no value> to "Expedite"' do
      subject { actions_ast.detect { |node| node[:action][:timestamp][:time] == '06:32:25 PM' } }

      it 'service_from' do
        expect(subject[:action][:description][0][:service_from]).to eq('<no value>')
      end

      it 'service_to' do
        expect(subject[:action][:description][0][:service_to]).to eq('Expedite')
      end
    end

    describe '01/27/2015 at 05:44:02 PM - Wen Luo moved this Card from Prioritised Backlog: Capability to In Analysis' do
      subject { actions_ast.detect { |node| node[:action][:timestamp][:time] == '05:44:02 PM' } }

      it 'from' do
        expect(subject[:action][:description][0][:from]).to eq('Prioritised Backlog: Capability')
      end

      it 'to' do
        expect(subject[:action][:description][0][:to]).to eq('In Analysis')
      end
    end

    describe '01/09/2015 at 02:52:51 PM - Fred Wu created this Card within the Prioritised Backlog: Capability Lane.' do
      subject { actions_ast.detect { |node| node[:action][:timestamp][:time] == '02:52:51 PM' } }

      it 'created_in' do
        expect(subject[:action][:description][0][:created_in]).to eq('Prioritised Backlog: Capability')
      end
    end

    describe '02/02/2015 at 12:53:46 PM - Yaowei Du set the status of this Card to Blocked' do
      subject { actions_ast.detect { |node| node[:action][:timestamp][:time] == '12:53:46 PM' } }

      it 'created_in' do
        expect(subject[:action][:description][0][:blocked_status]).to eq('Blocked')
      end
    end

    describe '02/03/2015 at 01:41:39 PM - Wen Luo set the status of this Card to Unblocked' do
      subject { actions_ast.detect { |node| node[:action][:timestamp][:time] == '01:41:39 PM' } }

      it 'created_in' do
        expect(subject[:action][:description][0][:blocked_status]).to eq('Unblocked')
      end
    end
  end
end
