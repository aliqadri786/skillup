class AddPriceToEnrollments < ActiveRecord::Migration[6.1]
  def change
    add_column :enrollments, :price, :integer
  end
end
