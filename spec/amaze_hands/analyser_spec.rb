RSpec.describe Analyser do
  include_context 'LeanKit P-217'
  include_context 'LeanKit P-217 analysable actions'

  subject { CardLaneRepository.all }

  before do
    Analyser.new(card).analyse
  end

  its(:count) { is_expected.to eq(6) }
end
