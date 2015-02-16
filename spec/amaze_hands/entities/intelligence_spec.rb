RSpec.describe Intelligence do
  subject { Intelligence.new }

  its(:cycle_time) { is_expected.to be_kind_of(Hash) }
  its(:wait_time)  { is_expected.to be_kind_of(Hash) }
end
