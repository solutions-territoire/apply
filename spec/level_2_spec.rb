require "rails_helper"

RSpec.describe "Level 2: few models methods" do
  describe "Intercommunality#communes_hash" do
    subject { interco.communes_hash }

    let!(:interco) do
      Intercommunality.create!(name: "Montpellier Métropole", siren: "243400017", form: "met")
    end

    it "returns a hash with :code_insee in keys and :name in values" do
      Commune.create!(code_insee: "34172", intercommunality: interco, name: "Montpellier")
      Commune.create!(code_insee: "34022", intercommunality: interco, name: "Baillargues")
      Commune.create!(code_insee: "34327", intercommunality: interco, name: "Vendargues")

      is_expected.to eq({
        "34022" => "Baillargues",
        "34172" => "Montpellier",
        "34327" => "Vendargues"
      })
    end
  end

  describe "Intercommunality#slug" do
    subject { interco.slug }

    let!(:interco) do
      Intercommunality.create!(name: "Montpellier Métropole", siren: "243400017", form: "met")
    end

    it "generates a slug on save" do
      expect(subject).to eq("montpellier-metropole")
    end

    it "no longer changes slug when name change" do
      interco.update(name: "Montpellier Méditerranée Métropole")
      expect(subject).to eq("montpellier-metropole")
    end

    it "regenerates slug on demand" do
      interco.update(name: "Montpellier Méditerranée Métropole", slug: nil)
      expect(subject).to eq("montpellier-mediterranee-metropole")
    end
  end

  describe "Commune.search" do
    let!(:montpellier) { Commune.create(code_insee: "34172", name: "Montpellier") }
    let!(:baillargues) { Commune.create(code_insee: "34022", name: "Baillargues") }
    let!(:vendargues)  { Commune.create(code_insee: "34327", name: "Vendargues") }
    let!(:perols)      { Commune.create(code_insee: "34198", name: "Pérols") }

    it "searches through communes by their name" do
      results = Commune.search("Montpellier")

      expect(results.size).to eq(1)
      expect(results).to include(montpellier)
    end

    it "searches with insensitive case" do
      results = Commune.search("PÉROLS")

      expect(results.size).to eq(1)
      expect(results).to include(perols)
    end

    it "searches with partial name" do
      results = Commune.search("argues")

      expect(results.size).to eq(2)
      expect(results).to include(baillargues)
      expect(results).to include(vendargues)
    end

    it "searches and escapes special characters" do
      results = Commune.search("%argue")

      expect(results.size).to eq(0)
    end

    it "is chainable" do
      results = Commune.search("montpellier")

      expect(results.limit(3)).to be_an(ActiveRecord::Relation)
      expect(results.pluck(:code_insee)).to be_an(Array)
    end
  end

  describe "Commune.to_hash" do
    subject { Commune.to_hash }

    it "returns a hash with :code_insee in keys and :name in values" do
      Commune.create(name: "Montpellier", code_insee: "34172")
      Commune.create(name: "Baillargues", code_insee: "34022")
      Commune.create(name: "Vendargues" , code_insee: "34327")

      is_expected.to eq({
        "34022" => "Baillargues",
        "34172" => "Montpellier",
        "34327" => "Vendargues"
      })
    end
  end
end
