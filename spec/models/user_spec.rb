# frozen_string_literal: true

require "spec_helper"

describe User do
  describe "fields" do
    fields = %i(name username crypted_password token)

    it { is_expected.to have_fields(*fields) }
  end

  describe "relationships" do
    it { is_expected.to have_many(:games) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name) }
    it { is_expected.to validate_presence_of(:password).on(:create) }
    it { is_expected.to validate_length_of(:password).on(:create) }
  end

  describe "indexes" do
    it { is_expected.to have_index_for(username: 1, token: 1) }
  end
end
