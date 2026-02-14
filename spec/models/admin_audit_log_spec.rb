require 'rails_helper'

RSpec.describe AdminAuditLog, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:admin).class_name("User") }
  end

  describe ".log!" do
    let(:admin) { create(:user, :admin) }
    let(:target_user) { create(:user) }

    it "creates an audit log entry" do
      expect {
        AdminAuditLog.log!(admin: admin, action: "banned_user", target: target_user, metadata: { reason: "Spam" })
      }.to change(AdminAuditLog, :count).by(1)
    end

    it "stores the correct attributes" do
      log = AdminAuditLog.log!(admin: admin, action: "banned_user", target: target_user, metadata: { reason: "Spam" })
      expect(log.admin).to eq(admin)
      expect(log.action).to eq("banned_user")
      expect(log.target_type).to eq("User")
      expect(log.target_id).to eq(target_user.id)
      expect(log.metadata).to eq({ "reason" => "Spam" })
    end

    it "works without a target" do
      log = AdminAuditLog.log!(admin: admin, action: "sync_tmdb")
      expect(log.target_type).to be_nil
      expect(log.target_id).to be_nil
    end
  end
end
