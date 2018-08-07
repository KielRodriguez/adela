require 'spec_helper'

describe OpeningPlanDatasetGenerator do
  describe '#generate' do
    let!(:organization) { create(:organization) }
    let!(:inventory) { create(:inventory, organization: organization) }
    let!(:catalog) { create(:catalog_with_datasets, organization: organization) }
    let!(:sector) { create(:sector_others)}

    before(:each) do
      OpeningPlanDatasetGenerator.new(inventory).generate
    end

    it 'should create a single dataset for the opening plan' do
      datasets = Dataset.where("title LIKE 'Plan de Apertura Institucional de #{organization.title}'")
      expect(datasets.size).to eq(1)
    end

    it 'should create a single dataset for the opening plan with sector otros' do
      datasets = Dataset.where("title LIKE 'Plan de Apertura Institucional de #{organization.title}'")
      expect(datasets.size).to eq(1)

      dataset = datasets.first
      expect(dataset.sector.title).to eq('Otros')
    end

    it 'should create single distribution for the opening plan dataset' do
      distributions = Distribution.where("title LIKE 'Plan de Apertura Institucional de #{organization.title}'")
      expect(distributions.size).to eq(1)
    end

    it 'should create sigle distribution for the opening plan dataset with media_type csv' do
      distributions = Distribution.where("title LIKE 'Plan de Apertura Institucional de #{organization.title}'")
      expect(distributions.size).to eq(1)

      distribution = distributions.first
      expect(distribution.media_type).to eq('csv')
    end
  end
end
