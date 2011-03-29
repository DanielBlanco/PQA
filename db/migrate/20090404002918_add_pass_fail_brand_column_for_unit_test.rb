class AddPassFailBrandColumnForUnitTest < ActiveRecord::Migration
  def self.up
  	add_column :unit_tests, :pass_brands, :string
  	add_column :unit_tests, :fail_brands, :string
  	remove_column :unit_tests, :brands
  end

  def self.down
  	add_column :unit_tests, :brands, :string
  	remove_column :unit_tests, :pass_brands
  	remove_column :unit_tests, :fail_brands
  end
end
