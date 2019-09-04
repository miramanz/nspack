
# require 'sequel_postgresql_triggers' # Uncomment this line for created_at and updated_at triggers.
# Sequel.migration do
#   up do
#     alter_table(:fruit_size_references) do
#       set_column_type(:size_reference, 'text[] USING CAST(size_reference AS text[])')
#       drop_constraint(:fruit_size_references_fruit_actual_counts_for_pack_id_size__key)
#       set_column_allow_null :fruit_actual_counts_for_pack_id
#     end
#   end
#
#   down do
#     alter_table(:fruit_size_references) do
#       set_column_type(:size_reference, 'text USING CAST(size_reference AS text)')
#       add_unique_constraint [:fruit_actual_counts_for_pack_id, :size_reference], name: :fruit_size_references_fruit_actual_counts_for_pack_id_size__key
#       add_foreign_key :fruit_size_references_fruit_actual_counts_for_pack_id_fkey, :fruit_actual_counts_for_packs, null: false, key: [:id]
#     end
#   end
# end
