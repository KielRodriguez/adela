require 'spec_helper'

describe InventoryDatasetGenerator do
  before(:each) do
    @inventory = create(:inventory, :elements)
  end

  describe '#generate' do
    before(:each) do
      InventoryDatasetGenerator.new(@inventory).generate
    end

    it 'should generate an organization catalog' do
      organization = @inventory.organization
      expect(organization.catalog).not_to be_nil
    end

    it 'should generate a dataset' do
      catalog = @inventory.organization.catalog
      expect(catalog.datasets.count).to eql(1)
    end

    it 'should generate a dataset with one distribution' do
      catalog = @inventory.organization.catalog
      dataset = catalog.datasets.last
      expect(dataset.distributions.count).to eql(1)
    end
  end
end
