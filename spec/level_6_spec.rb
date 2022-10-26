require "rails_helper"

RSpec.describe "Level 6: spatial representation" do
  describe "Commune#geometry" do
    let!(:montpellier) { Commune.create(code_insee: "34172", name: "Montpellier") }
    let!(:baillargues) { Commune.create(code_insee: "34022", name: "Baillargues") }

    before do
      ImportGeoJSONJob.perform_now(geojson)
    end

    let(:geojson) { "spec/fixtures/communes.geojson" }

    it "updates geometries" do
      expect { montpellier.reload }.to change(montpellier, :geometry).from(nil).to(be_a(RGeo::Feature::Polygon))
    end

    it "provides geometries in mercator" do
      montpellier.reload
      expect(montpellier.geometry.srid).to eq(4326)
    end

    it "computes coordinates from the center of the polygon" do
      montpellier.reload
      expect(montpellier.coordinates).to eq([43.613351, 3.869239])
    end
  end
end
