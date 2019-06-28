# require 'sequel_postgresql_triggers' # Uncomment this line for created_at and updated_at triggers.
Sequel.migration do
  # change do
    # Example for create table:
    # create_table(:table_name, ignore_index_errors: true) do
    #   primary_key :id
    #   foreign_key :some_id, :some_table_name, null: false, key: [:id]
    #
    #   String :my_uniq_name, null: false
    #   String :user_name
    #   String :password_hash, null: false
    #   String :email
    #   TrueClass :active, default: true
    #   DateTime :created_at, null: false
    #   DateTime :updated_at, null: false
    #
    #   index [:some_id], name: :fki_table_name_some_table_name
    #   index [:my_uniq_name], name: :table_name_unique_my_uniq_name, unique: true
    # end
  # end
  # Example for setting up created_at and updated_at timestamp triggers:
  # (Change table_name to the actual table name).
  up do
    add_column :rmt_classes, :grade, String
  end

  down do
    drop_column :rmt_classes, :grade
  end
end
