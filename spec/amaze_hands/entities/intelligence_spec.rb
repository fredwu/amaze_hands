RSpec.describe Intelligence do
  subject { Intelligence.new }

  its(:wait_days) { is_expected.to be_kind_of(Hash) }
end
