require 'spec_helper'

feature "opening plan management" do
  background do
    @opening_plan = create(:opening_plan_with_officials)
  end

  it "returns the organization opening plan" do
    get "/#{@opening_plan.organization.slug}/plan.json"
    expect(response).to match_response_schema("opening_plan")
  end
end
