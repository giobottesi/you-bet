require "rails_helper"

RSpec.describe "I18n configuration" do
  it "defaults to pt-BR" do
    expect(I18n.default_locale).to eq(:"pt-BR")
  end

  it "has pt-BR and en available" do
    expect(I18n.available_locales).to contain_exactly(:"pt-BR", :en)
  end

  it "loads pt-BR app_name and tagline" do
    I18n.with_locale(:"pt-BR") do
      expect(I18n.t("app_name")).to eq("You Bet")
      expect(I18n.t("tagline")).to eq("A matemática que as casas de apostas não mostram")
    end
  end

  it "loads en app_name and tagline" do
    I18n.with_locale(:en) do
      expect(I18n.t("app_name")).to eq("You Bet")
      expect(I18n.t("tagline")).to eq("The math betting companies don't show you")
    end
  end
end
