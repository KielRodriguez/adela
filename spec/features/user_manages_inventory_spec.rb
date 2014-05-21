require 'spec_helper'

feature User, 'manages inventory:' do

  background do
    @user = FactoryGirl.create(:user)
    given_logged_in_as(@user)
  end

  scenario "sees inventory link" do
    expect(page).to have_text("Plan de apertura")
    expect(page).to have_link("Inventario de datos")
  end

  scenario "sees file input", :js => true do
    visit new_inventory_path
    find('#inventory_csv_file').should_not be_nil
  end

  scenario "succeed to upload a csv file" do
    visit new_inventory_path
    tries_to_upload_the_file('inventory.csv')
    expect(page).to have_text "2 sets de datos completos y 0 sets de datos incompletos."
    sees_table_with_datasets
  end

  scenario "fails to upload an invalid csv file" do
    visit new_inventory_path
    tries_to_upload_the_file('invalid_file.txt')
    sees_error_message "Vuelve a subir el archivo corrigiendo las filas incorrectas. Asegúrate de que sea en formato CSV y con las columnas como la plantilla en blanco que descargaste."
  end

  scenario "fails to upload a csv file with invalid structure" do
    visit new_inventory_path
    tries_to_upload_the_file('invalid_inventory.csv')
    sees_error_message "Vuelve a subir el archivo corrigiendo las filas incorrectas. Asegúrate de que sea en formato CSV y con las columnas como la plantilla en blanco que descargaste."
  end

  scenario "sees a preview of an incorrect uploaded file" do
    visit new_inventory_path
    tries_to_upload_the_file('invalid_inventory.csv')
    expect(page).to have_text("0 sets de datos completos y 2 sets de datos incompletos.")
    sees_table_with_datasets
  end

  scenario "sees ignore and save action for uploaded partial invalid csv file" do
    visit new_inventory_path
    tries_to_upload_the_file('partial_invalid_inventory.csv')
    expect(page).to have_link "Ignorar incorrectas y guardar inventario"
  end

  scenario "sees save action for uploaded valid csv file" do
    visit new_inventory_path
    tries_to_upload_the_file('inventory.csv')
    expect(page).to have_link "Guardar inventario"
  end

  def tries_to_upload_the_file(file_name)
    attach_file('inventory_csv_file', "#{Rails.root}/spec/fixtures/files/#{file_name}")
    click_on("Subir inventario")
  end

  def given_has_uploaded_an_inventory(days_ago)
    @inventory = FactoryGirl.create(:inventory)
    @inventory.update_attributes(:organization_id => @user.organization_id, :created_at => days_ago)
  end

  def sees_table_with_datasets
    within "table#datasets_preview" do
      expect(page).to have_text("Presupuesto de egresos 2013")
      expect(page).to have_text("Recetas médicas de Octubre")
    end
  end

end