require "rails_helper"

RSpec.describe BetType do
  before { Rails.application.load_seed }

  describe ".all" do
    it "returns 7 bet types" do
      expect(BetType.all.length).to eq(7)
    end

    it "returns BetType instances" do
      expect(BetType.all).to all(be_a(BetType))
    end
  end

  describe ".find" do
    it "returns a BetType for valid key" do
      bet_type = BetType.find("sports_singles")
      expect(bet_type.key).to eq("sports_singles")
    end

    it "raises for invalid key" do
      expect { BetType.find("nonexistent") }.to raise_error(ArgumentError)
    end
  end

  describe "#house_edge" do
    it "returns the house edge from ReferenceValue" do
      expect(BetType.find("sports_singles").house_edge).to be_within(0.001).of(0.06)
    end

    it "returns lottery house edge" do
      expect(BetType.find("lottery").house_edge).to be_within(0.01).of(0.54)
    end
  end

  describe "TYPES" do
    it "has a matching house edge seed for each type" do
      BetType::TYPES.each do |key|
        expect { ReferenceValue.get("#{key}.house_edge") }.not_to raise_error
      end
    end
  end
end
