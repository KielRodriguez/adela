class InventoryElement < ActiveRecord::Base
  # compliant validations
  validate :private_mandatory_fields, if: :private?
  validate :mandatory_fields

  validates :inventory, presence: true
  belongs_to :inventory

  private

  def mandatory_fields
    fields = %i(row responsible dataset_title resource_title description private media_type)
    fields.each do |field|
      warnings.add(field) if send(field).nil?
    end
  end

  def private_mandatory_fields
    warnings.add(:access_comment, :blank) if access_comment.nil?
  end
end
