require 'spec_helper'

describe Inventory do

  context 'valid inventories' do

    shared_examples 'a valid inventory file' do
      before(:each) do
        file = File.new(csv_file)
        @inventory = FactoryGirl.create(:inventory, csv_file: file)
      end

      it 'should be valid with mandatory fields' do
        @inventory.should be_valid
      end

      it 'should not be valid without an organization' do
        @inventory.organization_id = nil
        @inventory.should_not be_valid
      end

      it 'should contain valid datasets' do
        @inventory.has_valid_datasets?.should be_true
      end
    end

    it_behaves_like 'a valid inventory file' do
      let(:csv_file) { "#{Rails.root}/spec/fixtures/files/inventory.csv" }
    end

    it_behaves_like 'a valid inventory file' do
      let(:csv_file) { "#{Rails.root}/spec/fixtures/files/inventory-v3.csv" }
    end
  end

  context 'compliant inventories' do
    shared_examples 'a compliant inventory' do
      before(:each) do
        file = File.new(csv_file)
        @inventory = FactoryGirl.create(:inventory, csv_file: file)
      end

      it 'should be valid' do
        @inventory.should be_valid
      end

      it 'should be compliant' do
        @inventory.compliant?.should be true
      end
    end

    it_behaves_like 'a compliant inventory' do
      let(:csv_file) { "#{Rails.root}/spec/fixtures/files/inventory-accrual-periodicity.csv" }
    end
  end

  context 'noncompliant inventories' do
    before(:each) do
      file = File.new("#{Rails.root}/spec/fixtures/files/inventory-noncompliant.csv")
      @inventory = FactoryGirl.create(:inventory, csv_file: file)
    end

    it 'should be valid' do
      @inventory.should be_valid
    end

    it 'should be compliant' do
      @inventory.compliant?.should be false
    end
  end

  context 'inventory with an opening plan' do
    before(:each) do
      file = File.new("#{Rails.root}/spec/fixtures/files/inventory-with-opening-plan.csv")
      @inventory = FactoryGirl.create(:published_inventory, csv_file: file)
    end

    it 'should be valid with mandatory fields' do
      @inventory.should be_valid
    end

    it 'should create an opening plan' do
      OpeningPlan.count.should eql(1)
    end

    it 'should delete previus opening plan' do
      @inventory.save
      OpeningPlan.count.should eql(1)
    end
  end

  context 'invalid inventories' do
    shared_examples 'an invalid inventory file' do
      before(:each) do
        file = File.new(csv_file)
        @inventory = FactoryGirl.build(:inventory, csv_file: file)
      end

      it "should not be valid with an invalid file" do
        @inventory.should_not be_valid
      end
    end

    shared_examples 'an inventory with invalid datasets' do
      before(:each) do
        file = File.new(csv_file)
        @inventory = FactoryGirl.build(:inventory, csv_file: file)
      end

      it "should contain valid datasets" do
        @inventory.has_valid_datasets?.should be_false
      end
    end

    context 'an inventory with invalid landing page' do

      it_behaves_like 'an inventory with invalid datasets' do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/inventory-v3-invalid-landing-page.csv" }
      end

      it_behaves_like 'an inventory with invalid datasets' do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/inventory-v3-blank-landing-page.csv" }
      end
    end

    context "an inventory with non alphanumeric keywords in dataset" do
      it_behaves_like "an invalid inventory file" do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/inventory-non-alphanumeric.csv" }
      end

      it_behaves_like "an inventory with invalid datasets" do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/inventory-non-alphanumeric.csv" }
      end
    end

    context "an inventory file with a null download url" do
      it_behaves_like "an invalid inventory file" do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/inventory-null-download-url.csv" }
      end

      it_behaves_like "an inventory with invalid datasets" do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/inventory-null-download-url.csv" }
      end
    end

    context "inventory with duplicated titles in datasets" do
      it_behaves_like "an invalid inventory file" do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/inventory-with-duplicated-title.csv" }
      end
    end

    context "inventory with duplicated identifiers in datasets" do
      it_behaves_like "an invalid inventory file" do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/inventory-with-duplicated-identifiers.csv" }
      end
    end

    context "blank file" do
      it_behaves_like "an invalid inventory file" do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/invalid_file.txt" }
      end
    end

    context "file with ragged rows" do
      it_behaves_like "an invalid inventory file" do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/ragged_rows_inventory.csv" }
      end
    end

    context "file with a blank row" do
      it_behaves_like "an invalid inventory file" do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/blank_rows_inventory.csv" }
      end
    end

    context "file with a row with all fields in blank" do
      it_behaves_like "an invalid inventory file" do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/blank_rows_inventory-2.csv" }
      end
    end

    context "csv file with no resources" do
      it_behaves_like "an invalid inventory file" do
        let(:csv_file) { "#{Rails.root}/spec/fixtures/files/inventory-no-resources.csv" }
      end
    end
  end
end
