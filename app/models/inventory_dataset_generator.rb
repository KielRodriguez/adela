class InventoryDatasetGenerator
  attr_reader :inventory, :organization, :catalog

  def initialize(inventory)
    @inventory = inventory
    @organization = inventory.organization
    @catalog = organization_catalog
  end

  def generate
    dataset = build_dataset
    build_distribution(dataset)
    build_sector(dataset) if @organization.sectors.present?
    dataset.save
  end

  private

  def organization_catalog
    @organization.catalog.present? ? @organization.catalog : build_catalog
  end

  def build_catalog
    @organization.build_catalog(published: false)
  end

  def build_dataset
    @catalog.datasets.build do |dataset|
      dataset.identifier = 'inventario-institucional-de-datos'
      dataset.title = 'Inventario Institucional de Datos'
      dataset.description = "Inventario Institucional de Datos de #{@organization.title}"
      dataset.keyword = 'inventario'
      dataset.modified = Time.current.iso8601
      dataset.contact_position = ENV_CONTACT_POSITION_NAME
      dataset.contact_point = organization_administrator.try(:name)
      dataset.mbox = organization_administrator.try(:email)
      dataset.temporal = Time.current.year
      dataset.landing_page = @organization.landing_page
      dataset.accrual_periodicity = 'irregular'
      dataset.publish_date = DateTime.new(2015, 8, 28)
    end
  end

  def organization_administrator
    @organization.administrator.try(:user)
  end

  def build_sector(dataset)
    dataset.build_dataset_sector do |dataset_sector|
      dataset_sector.sector_id = @organization.sectors.first.id
    end
  end

  def build_distribution(dataset)
    dataset.distributions.build do |distribution|
      distribution.title = 'Inventario Institucional de Datos'
      distribution.description = "Inventario Institucional de Datos de #{@organization.title}"
      distribution.download_url = @inventory.spreadsheet_file.url
      distribution.media_type = 'application/vnd.ms-excel'
      distribution.byte_size = @inventory.spreadsheet_file.file.size
      distribution.temporal = Time.current.year
    end
  end
end
