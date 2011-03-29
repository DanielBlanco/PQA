class RemovingDefaultsFromTables < ActiveRecord::Migration
  def self.up

    remove_column :code_reviews, :ticket
    remove_column :projects, :ticket
    remove_column :unit_tests, :fsd_usecase_id
    remove_column :walkthroughs, :issue

    add_column    :code_reviews, :ticket, :string
    add_column    :projects, :ticket, :string
    add_column    :unit_tests, :fsd_usecase_id, :string
    add_column    :walkthroughs, :issue, :string
  end

  def self.down
    # I will not create a down in here.
  end
end
