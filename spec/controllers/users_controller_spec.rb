# frozen_string_literal: true

require "spec_helper"

describe UsersController do
  describe "POST #create" do
    let(:params) { { first_name: "API", last_name: "Test", cell_phone: "00000", zip_code: "4444" } }

    context "with valid params" do
      it "creates a contact" do
      end
    end

    context "with invalid params" do
      it "renders error message" do
      end
    end
  end
end

