# frozen_string_literal: true

require "spec_helper"

describe User do
  describe "fields" do
    fields = %i(name username crypted_password token)

    it { is_expected.to have_fields(*fields) }
    it { is_expected.to have_timestamps.shortened }
  end

  describe "relationships" do
    it { is_expected.to have_many(:games) }
  end

  describe "validations" do
    fields = %i(name username password)

    fields.each do |field|
      it { is_expected.to validate_presence_of(field) }
    end
  end

  describe "indexes" do
    it { is_expected.to have_index_for(username: 1, token: 1) }
  end
end
