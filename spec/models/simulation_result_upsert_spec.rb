require 'rails_helper'

RSpec.describe SimulationResultUpsert do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:bet_type_key) }
    it { is_expected.to validate_presence_of(:house_edge) }
    it { is_expected.to validate_presence_of(:weekly_amount_cents) }
  end

  describe '#upsert' do
    let(:attributes) do
      { bet_type_key: 'sports_singles', house_edge: 0.06, weekly_amount_cents: 5000, simulation_count: 200 }
    end

    it 'creates a simulation result on a cache miss (whole chain)' do
      expect { described_class.upsert(attributes) }.to change(SimulationResult, :count).by(1)
    end

    it 'returns a persisted record carrying the five timeframes' do
      record = described_class.upsert(attributes)
      expect(record).to be_persisted
      expect(record.results.keys).to contain_exactly('month_1', 'months_6', 'year_1', 'years_2', 'years_5')
    end

    it 'reuses the stored result on a cache hit instead of creating a second row' do
      described_class.upsert(attributes)
      expect { described_class.upsert(attributes) }.not_to change(SimulationResult, :count)
    end

    it 'freezes the first result — identical inputs return identical results despite randomness' do
      first = described_class.upsert(attributes).results
      second = described_class.upsert(attributes).results
      expect(second).to eq(first)
    end

    let(:changed_inputs) do
      { bet_type_key: 'roulette', house_edge: 0.10, weekly_amount_cents: 9900, simulation_count: 500 }
    end

    it 'misses the cache when any single input changes' do
      described_class.upsert(attributes)

      changed_inputs.each do |attribute, value|
        expect { described_class.upsert(attributes.merge(attribute => value)) }
          .to change(SimulationResult, :count).by(1)
      end
    end

    it 'returns false on invalid input without touching the table' do
      expect { described_class.upsert(attributes.merge(bet_type_key: nil)) }
        .not_to change(SimulationResult, :count)
      expect(described_class.upsert(attributes.merge(bet_type_key: nil))).to be(false)
    end
  end
end
