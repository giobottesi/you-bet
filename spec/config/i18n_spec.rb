require "rails_helper"

RSpec.describe "I18n configuration" do
  describe "defaults" do
    it "sets pt-BR as default locale" do
      expect(I18n.default_locale).to eq(:"pt-BR")
    end

    it "includes pt-BR and en as available locales" do
      expect(I18n.available_locales).to include(:"pt-BR", :en)
    end
  end

  describe "pt-BR translations" do
    around { |example| I18n.with_locale(:"pt-BR", &example) }

    it "loads app name" do
      expect(I18n.t("app_name")).to eq("You Bet")
    end

    it "loads tagline" do
      expect(I18n.t("tagline")).to eq("A matemática que as casas de apostas não mostram")
    end

    it "loads landing page strings" do
      expect(I18n.t("landing.submit")).to eq("Simular")
      expect(I18n.t("landing.question_bet_type")).to eq("O que você apostaria?")
    end

    it "loads bet types" do
      expect(I18n.t("bet_types.sports_singles")).to eq("Apostas esportivas")
      expect(I18n.t("bet_types.slots")).to eq("Tigrinho / Caça-níquel")
    end

    it "loads timeframes" do
      expect(I18n.t("timeframes.month_1")).to eq("1 mês")
      expect(I18n.t("timeframes.years_5")).to eq("5 anos")
    end

    it "loads help resources" do
      expect(I18n.t("help.need_help")).to eq("Precisa de ajuda?")
      expect(I18n.t("help.cvv")).to eq("CVV 188")
    end
  end

  describe "en translations" do
    around { |example| I18n.with_locale(:en, &example) }

    it "loads app name" do
      expect(I18n.t("app_name")).to eq("You Bet")
    end

    it "loads tagline" do
      expect(I18n.t("tagline")).to eq("The math betting companies don't show you")
    end

    it "loads landing page strings" do
      expect(I18n.t("landing.submit")).to eq("Simulate")
    end

    it "loads bet types" do
      expect(I18n.t("bet_types.sports_singles")).to eq("Sports betting")
    end
  end

  describe "locale parity" do
    let(:app_keys) { %w[app_name tagline landing bet_types amounts results timeframes help navigation footer locale_toggle] }

    it "has matching app keys in both locales" do
      I18n.backend.reload!
      I18n.backend.eager_load!

      pt_keys = flatten_keys(I18n.backend.translations[:"pt-BR"]).select { |k| app_keys.include?(k.split(".").first) }
      en_keys = flatten_keys(I18n.backend.translations[:en]).select { |k| app_keys.include?(k.split(".").first) }

      missing_in_en = pt_keys - en_keys
      missing_in_pt = en_keys - pt_keys

      expect(missing_in_en).to be_empty, "EN missing: #{missing_in_en.join(', ')}"
      expect(missing_in_pt).to be_empty, "PT-BR missing: #{missing_in_pt.join(', ')}"
    end
  end

  def flatten_keys(hash, prefix = nil)
    hash.each_with_object([]) do |(key, value), keys|
      full_key = [prefix, key].compact.join(".")
      if value.is_a?(Hash)
        keys.concat(flatten_keys(value, full_key))
      else
        keys << full_key
      end
    end
  end
end
