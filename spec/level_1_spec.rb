require "rails_helper"

RSpec.describe "Level 1: models" do
  describe "Commune", type: :model do
    def self.described_class
      Commune
    end

    it { is_expected.to belong_to(:intercommunality).required(false) }
    it { is_expected.to have_many(:streets) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:code_insee) }

    it { is_expected.to allow_value("34172").for(:code_insee) }
    it { is_expected.to_not allow_value("172").for(:code_insee) }
  end

  describe "Intercommunality", type: :model do
    def self.described_class
      Intercommunality
    end

    it { is_expected.to have_many(:communes) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:siren) }
    it { is_expected.to validate_uniqueness_of(:siren).case_insensitive }
    it { is_expected.to validate_inclusion_of(:form).in_array(%w[ca cu cc met]) }

    it { is_expected.to allow_value("243400017").for(:siren) }
    it { is_expected.to_not allow_value("243 400 017").for(:siren) }
    it { is_expected.to_not allow_value("24340001700").for(:siren) }
  end

  describe "Street", type: :model do
    def self.described_class
      Street
    end

    it { is_expected.to have_many(:communes) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_numericality_of(:from).allow_nil }
    it { is_expected.to validate_numericality_of(:to).allow_nil }

    it "validate that :to is greater than :from" do
      street = Street.create(title: "AVENUE DES CHAMPS ELYSEES", from: 666, to: 4)

      expect(street).to be_new_record
      expect(street.errors).to be_include(:to)
      expect(street.errors).to_not be_include(:from)
    end
  end
end
