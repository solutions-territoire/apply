require "rails_helper"

RSpec.describe "Level 3: regexes" do
  describe "Parcel number" do
    subject { Parcel::NUMBER_REGEXP }

    it "is composed by a prefix, a section and a plan" do
      is_expected.to match("127 DC 1207").with_captures(prefix: "127", section: "DC", plan: "1207")
    end

    it "accepts numbers without prefix" do
      is_expected.to match("AB 0001").with_captures(prefix: nil, section: "AB", plan: "0001")
    end

    it "accepts numbers composed of a section with only 1 letter" do
      is_expected.to match("A 0204").with_captures(prefix: nil, section: "A", plan: "0204")
    end

    it "accepts numbers composed of a section with 2 digits (in Alsace)" do
      is_expected.to match("01 0001").with_captures(prefix: nil, section: "01", plan: "0001")
    end

    it "accepts numbers composed prefix and section with digits" do
      is_expected.to match("105 01 0001").with_captures(prefix: "105", section: "01", plan: "0001")
    end

    it "accepts numbers composed of a plan with only 1 digit when section is composed of letters" do
      is_expected.to match("A 2").with_captures(prefix: nil, section: "A", plan: "2")
    end

    it "doesn't accept section with only 1 digit" do
      is_expected.not_to match("1 0001")
    end

    it "doesn't accept plan without 4 digits when section is composed of digits" do
      is_expected.not_to match("01 01")
    end

    it "doesn't accept prefix prefix without 3 digits" do
      is_expected.not_to match("1 DC 1207")
    end

    it "accepts numbers where section composed of 1 zero and 1 letter but doesn't capture the zero" do
      is_expected.to match("0Z 0041").with_captures(prefix: nil, section: "Z", plan: "0041")
    end
  end
end
