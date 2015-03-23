RSpec.describe Producers::ControllLimitsProducer do
  let(:producer) { described_class.new(intel) }

  subject(:intel) { Intelligence.new }

  before do
    intel.cycle_time = {
      '2015-4' => {
        combined_rolling: {
          item_values:        [9.5, 4.0, 6.5, 6.5, 3.5],
          count:              5,
          sum:                30,
          mean:               6,
          median:             6.5,
          standard_deviation: 4.05,
          upper_limit:        8.52,
          lower_limit:        5.28
        },
        combined: {}
      },
      '2015-5' => {
        combined_rolling: {
          item_values:        [9.5, 4.0, 6.5, 6.5, 3.5, 3.5, 15.5, 8.5, 11.5],
          count:              9,
          sum:                69.0,
          mean:               7.7,
          median:             6.5,
          standard_deviation: 4.05,
          upper_limit:        8.52,
          lower_limit:        5.28
        },
        combined: {}
      }
    }
  end

  describe '#apply' do
    before do
      producer.apply
    end

    context 'wait times' do
      its(:cycle_time) do
        is_expected.to eq(
          '2015-4' => {
            combined_rolling: {
              item_values:        [9.5, 4.0, 6.5, 6.5, 3.5],
              count:              5,
              sum:                30,
              mean:               6,
              median:             6.5,
              standard_deviation: 4.05,
              upper_limit:        8.52,
              lower_limit:        5.28
            },
            combined: {
              ucl: 11.69,
              cl:  7.7,
              lcl: 3.71
            }
          },
          '2015-5' => {
            combined_rolling: {
              item_values:        [9.5, 4.0, 6.5, 6.5, 3.5, 3.5, 15.5, 8.5, 11.5],
              count:              9,
              sum:                69.0,
              mean:               7.7,
              median:             6.5,
              standard_deviation: 4.05,
              upper_limit:        8.52,
              lower_limit:        5.28
            },
            combined: {
              ucl: 11.69,
              cl:  7.7,
              lcl: 3.71
            }
          }
        )
      end
    end
  end
end
