require "rails_helper"

RSpec.describe "Reports::ItemizedDistributions", type: :request do
  let(:default_params) do
    {organization_name: @organization.to_param}
  end

  describe "while signed in" do
    before do
      sign_in @user
    end

    describe "GET #index" do
      subject do
        get reports_itemized_distributions_path(default_params.merge(format: response_format))
        response
      end
      let(:response_format) { "html" }

      it { is_expected.to have_http_status(:success) }
    end

    context "without any distributions" do
      it "can load the page" do
        get reports_itemized_distributions_path(default_params)
        expect(response.body).to include("Itemized Distributions")
      end

      it "has no items" do
        get reports_itemized_distributions_path(default_params)
        expect(response.body).to include("No itemized distributions found for the selected date range.")
      end
    end

    context "with a distribution" do
      let(:distribution) { create(:distribution, :with_items, organization: @organization) }

      it "Shows an item from the distribution" do
        distribution
        get reports_itemized_distributions_path(default_params)
        expect(response.body).to include(distribution.items.first.name)
      end
    end
  end

  describe "while not signed in" do
    describe "GET /index" do
      subject do
        get reports_itemized_distributions_path(default_params)
        response
      end

      it "redirect to login" do
        is_expected.to redirect_to(new_user_session_path)
      end
    end
  end
end
