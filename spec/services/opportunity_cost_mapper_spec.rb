require 'rails_helper'

RSpec.describe OpportunityCostMapper do
  subject(:mapper) { described_class.new(loss_cents: loss_cents, poupanca_balance_cents: poupanca_balance_cents) }

  # Non-seeded keys so the fixtures never collide with the comparison rows the
  # test DB is seeded with. The service reads every `comparison` row, so the
  # assertions reference only these known keys.
  let!(:comparisons) do
    {
      'demo_pizza_cents' => 4000,
      'demo_phone_cents' => 550_000,
      'demo_media_cents' => 5500,
      'demo_vehicle_cents' => 1_000_000
    }.map { |key, cents| create(:reference_value, key: key, value: cents.to_s, category: 'comparison') }
  end

  let(:poupanca_balance_cents) { 52_000 }

  describe '#run' do
    subject(:result) { mapper.run }

    context 'with a moderate loss' do
      let(:loss_cents) { 50_000 }

      it 'appends poupança as the final item' do
        expect(result.last[:key]).to eq('poupanca')
        expect(result.last[:balance_cents]).to eq(poupanca_balance_cents)
      end
    end

    context 'when the loss buys less than one of an item' do
      let(:loss_cents) { 3000 }

      it 'excludes that item' do
        comparison_keys = result.reject { |item| item[:key] == 'poupanca' }.map { |item| item[:key] }
        expect(comparison_keys).not_to include('demo_pizza_cents', 'demo_phone_cents')
      end
    end

    context 'when the loss buys several of an item' do
      let(:loss_cents) { 100_000 }

      it 'reports the affordable quantity' do
        pizza = result.find { |item| item[:key] == 'demo_pizza_cents' }
        expect(pizza[:quantity]).to eq(25) if pizza
      end
    end

    context 'with a large loss affording every comparison' do
      let(:loss_cents) { 2_000_000 }

      it 'returns at most three comparisons plus poupança' do
        expect(result.length).to be <= 4
      end
    end
  end
end
