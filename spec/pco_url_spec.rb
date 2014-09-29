require "spec_helper"

Applications = [
  :accounts,
  :avatars,
  :services,
  :check_ins,
  :people,
  :registrations,
  :resources
]

describe PCO::URL do
  describe "defaults" do
    describe "development" do
      before do
        Rails.env = "development"
      end

      Applications.map(&:to_s).each do |app|
        it "has an #{app} URL" do
          expect(PCO::URL.send(app)).to eq("http://#{app.gsub('_','-')}.pco.dev")
        end
      end
    end

    describe "staging" do
      before do
        Rails.env = "staging"
      end

      Applications.map(&:to_s).each do |app|
        it "has an #{app} URL" do
          expect(PCO::URL.send(app)).to eq("https://#{app.gsub('_','-')}-staging.planningcenteronline.com")
        end
      end
    end

    describe "production" do
      before do
        Rails.env = "production"
      end

      Applications.map(&:to_s).each do |app|
        it "has an #{app} URL" do
          expect(PCO::URL.send(app)).to eq("https://#{app.gsub('_','-')}.planningcenteronline.com")
        end
      end
    end

    describe "test" do
      before do
        Rails.env = "test"
      end

      Applications.map(&:to_s).each do |app|
        it "has an #{app} URL" do
          expect(PCO::URL.send(app)).to eq("http://#{app.gsub('_','-')}.pco.test")
        end
      end
    end
  end

  context "with path starting with /" do
    Applications.map(&:to_s).each do |app|
      it "has an #{app} URL with path" do
        expect(PCO::URL.send(app, "/test")).to eq("http://#{app.gsub('_','-')}.pco.test/test")
      end
    end
  end

  context "with path NOT starting with /" do
    Applications.map(&:to_s).each do |app|
      it "has an #{app} URL with path" do
        expect(PCO::URL.send(app, "test")).to eq("http://#{app.gsub('_','-')}.pco.test/test")
      end
    end
  end

  describe "overrides" do
    describe "development with accounts URL override" do
      before do
        Rails.env = "development"
        ENV["ACCOUNTS_URL"] = "http://bazinga.com"
      end

      it "has a custom accounts URL" do
        expect(PCO::URL.accounts).to eq("http://bazinga.com")
      end
    end

    describe "Rails.env staging with DEPLOY_ENV override" do
      before do
        Rails.env = "development"
        ENV["ACCOUNTS_URL"] = nil
        ENV["DEPLOY_ENV"] = "staging"
      end

      it "loads the DEPLOY_ENV URLs" do
        expect(PCO::URL.accounts).to eq("https://accounts-staging.planningcenteronline.com")
      end
    end

    describe "Rails.env staging with DEPLOY_ENV override and ACCOUNTS_URL override" do
      before do
        Rails.env = "development"
        ENV["ACCOUNTS_URL"] = "http://accounts-test1.planningcenteronline.com"
        ENV["DEPLOY_ENV"] = "staging"
      end

      it "loads the DEPLOY_ENV URLs" do
        expect(PCO::URL.accounts).to eq("http://accounts-test1.planningcenteronline.com")
      end
    end
  end

end
