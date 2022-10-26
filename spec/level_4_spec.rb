require "rails_helper"

RSpec.describe "Level 4: controllers" do
  describe "CommunesController", type: :request do
    def self.described_class
      CommunesController
    end

    let!(:commune) do
      Commune.create!(code_insee: "34172", name: "Montpellier")
    end

    describe "#index" do
      it "responds with success in JSON" do
        get("/communes", headers: {"Accept" => "application/json"})
        expect(response).to have_http_status(:success)
      end

      it "is not acceptable in HTML" do
        get("/communes", headers: {"Accept" => "text/html"})
        expect(response).to have_http_status(:not_acceptable)
      end

      it "accepts and returns a CSV file" do
        get("/communes", headers: {"Accept" => "text/csv"})
        expect(response).to have_http_status(:success)
        expect(response.headers["Content-Disposition"]).to include("export_communes.csv")
        expect(response.body).to eq(<<~CSV)
          code_insee;name
          34172;Montpellier
        CSV
      end
    end

    describe "#create" do
      it "is forbidden" do
        post("/communes")
        expect(response).to have_http_status(:forbidden)
      end
    end

    describe "#show" do
      it "requires :code_insee to identify resource" do
        get("/communes/#{commune.id}")
        expect(response).to have_http_status(:not_found)
      end

      it "responds with success" do
        get("/communes/#{commune.code_insee}")
        expect(response).to have_http_status(:success)
      end
    end

    describe "#update" do
      it "requires :code_insee to identify resource" do
        put("/communes/#{commune.id}")
        expect(response).to have_http_status(:not_found)
      end

      it "requires attributes to update" do
        put("/communes/#{commune.code_insee}")
        expect(response).to have_http_status(:bad_request)
      end

      it "updates the resource and responds with empty response" do
        put("/communes/#{commune.code_insee}", params: {commune: {name: "Commune de Montpellier"}})

        expect(response).to have_http_status(:no_content)
        expect { commune.reload }.to change(commune, :name).to("Commune de Montpellier")
      end
    end
  end
end
