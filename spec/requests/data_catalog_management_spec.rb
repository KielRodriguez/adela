require 'spec_helper'

feature 'data catalog management' do
  background do
    @organization = create(:organization)
  end

  scenario 'can consume published catalog data' do
    create(:catalog, :datasets, organization: @organization)
    get "/#{@organization.slug}/catalogo.json"
    json_response = JSON.parse(response.body)
    json_response['title'].should eql("Catálogo de datos abiertos de #{@organization.title}")
    json_response['dataset'].should_not be_empty
  end

  scenario 'can\'t consume unpublished catalog data' do
    create(:catalog, :unpublished, organization: @organization)
    get "/#{@organization.slug}/catalogo.json"
    json_response = JSON.parse(response.body)
    expect(json_response).to eql({})
  end

  scenario 'can see all the catalogs available through the api' do
    create(:catalog)
    create(:catalog, :unpublished)
    get '/api/v1/organizations/catalogs.json'
    json_response = JSON.parse(response.body)
    json_response.size.should == 1
  end

  scenario 'catalog will have correct DCAT key names' do
    create(:catalog, :datasets, organization: @organization)

    dcat_keys = %w(title description homepage issued modified language license dataset)
    dcat_dataset_keys = %w(identifier title description keyword modified contact_point spatial landing_page language publisher distribution)
    dcat_distribution_keys = %w(title description license download_url media_type byte_size temporal spatial)

    get "/#{@organization.slug}/catalogo.json"
    json_response = JSON.parse(response.body)
    json_response.keys.should eq(dcat_keys)
    json_response['dataset'].last.keys.sort.should eq(dcat_dataset_keys.sort)
    json_response['dataset'].last['distribution'].last.keys.sort.should eq(dcat_distribution_keys.sort)
  end
end
