# frozen_string_literal: true

# Base class for all database repository classes to inherit from.
#
# Contains several helper methods that can be called on the
# inherited repo or can be overridden. These mostly handle reads
# and writes.
#
# Contains a few helper directives to be called during inheritance
# by the sub class that will generate appropriate methods on the
# sub class.
# For example basic CRUD calls for a particular table using:
#     crud_calls_for
class BaseRepo # rubocop:disable Metrics/ClassLength
  include Crossbeams::Responses

  # Wraps Sequel's transaction so that it is not exposed to calling code.
  #
  # @param block [Block] the work to take place within the transaction.
  # @return [void] whatever the block returns.
  def transaction(&block)
    DB.transaction(&block)
  end

  # Return all rows from a table as instances of the given wrapper.
  #
  # @param table_name [Symbol] the db table name.
  # @param wrapper [Class] the class of the object to return.
  # @param args [Hash] the optional where-clause conditions.
  # @return [Array] the table rows.
  def all(table_name, wrapper, args = nil)
    ds = all_hash(table_name, args, true)
    dataset_wrapped(ds, wrapper)
  end

  # Take a Sequel dataset and return the result with each row
  # as an instance of the wrapper.
  #
  # @param dataset [Sequel::Dataset] the dataset.
  # @param wrapper [Class] the class of the objects to return.
  # @return [Array] the table rows.
  def dataset_wrapped(dataset, wrapper)
    dataset.with_row_proc(->(h) { wrapper.new(h) }).all
  end

  # Return all rows from a table as Hashes or just the Sequel::Dataset
  # without running the query.
  #
  # @param table_name [Symbol] the db table name.
  # @param args [Hash] the optional where-clause conditions.
  # @param return_dataset [boolean] if true, returns the Sequel dataset, else the records. Default is false.
  # @return [Array] the table rows.
  def all_hash(table_name, args = nil, return_dataset = false)
    ds = args.nil? ? DB[table_name] : DB[table_name].where(args)
    return_dataset ? ds : ds.all
  end

  # Find a row in a table. Raises an exception if it is not found.
  #
  # @param table_name [Symbol] the db table name.
  # @param wrapper [Class] the class of the object to return.
  # @param id [Integer] the id of the row.
  # @return [Object] the row wrapped in a new wrapper object.
  def find!(table_name, wrapper, id)
    hash = find_hash(table_name, id)
    # raise Crossbeams::FrameworkError, "#{table_name}: id #{id} not found." if hash.nil?
    raise "#{table_name}: id #{id} not found." if hash.nil?

    wrapper.new(hash)
  end

  # Find a row in a table. Returns nil if it is not found.
  #
  # @param table_name [Symbol] the db table name.
  # @param wrapper [Class] the class of the object to return.
  # @param id [Integer] the id of the row.
  # @return [Object, nil] the row wrapped in a new wrapper object.
  def find(table_name, wrapper, id)
    hash = find_hash(table_name, id)
    return nil if hash.nil?

    wrapper.new(hash)
  end

  # Find a row in a table. Returns nil if it is not found.
  #
  # @param table_name [Symbol] the db table name.
  # @param id [Integer] the id of the row.
  # @return [Hash, nil] the row as a Hash.
  def find_hash(table_name, id)
    where_hash(table_name, id: id)
  end

  # Find the first row in a table matching some condition.
  # Returns nil if it is not found.
  #
  # @param table_name [Symbol] the db table name.
  # @param wrapper [Class] the class of the object to return.
  # @param args [Hash] the where-clause conditions.
  # @return [Object, nil] the row wrapped in a new wrapper object.
  def where(table_name, wrapper, args)
    hash = where_hash(table_name, args)
    return nil if hash.nil?

    wrapper.new(hash)
  end

  # Find the first row in a table matching some condition.
  # Returns nil if it is not found.
  #
  # @param table_name [Symbol] the db table name.
  # @param args [Hash] the where-clause conditions.
  # @return [Hash, nil] the row as a Hash.
  def where_hash(table_name, args)
    DB[table_name].where(args).first
  end

  # Checks to see if a row exists that meets the given requirements.
  #
  # @param table_name [Symbol] the db table name.
  # @param args [Hash] the where-clause conditions.
  # @return [Boolean] true if the row exists.
  def exists?(table_name, args)
    DB.select(1).where(DB[table_name].where(args).exists).one?
  end

  # Find a row in a table with one or more associated sub-tables, parent tables or lookup functions.
  # Returns nil if the row is not found.
  # Returns a Hash if no wrapper is provided, else an instance of the wrapper class.
  #
  # Each Hash in the sub_tables array must include:
  # sub_table: Symbol - if no other options provided, assumes that the sub table has a column named "main_table_id" and all columns are returned.
  #
  # Optional keys:
  # columns: Array of Symbols - one for each desired column. If not present, all columns are returned
  # uses_join_table: Boolean - if true, will create a join table name using main_table and sub_table names sorted and joined with "_".
  # join_table: String - if present, use this as the join table.
  # active_only: Boolean (Only return active rows.)
  # inactive_only: Boolean (Only return inactive rows. The key in the main hash becomes :inactive_sub_table)
  #
  # examples:
  #     find_with_association(:security_groups, 123, sub_tables: [{ sub_table: :security_permissions, uses_join_table: true }], wrapper: SecurityGroupWithPermissions)
  #     find_with_association(:security_groups, 123, sub_tables: [{ sub_table: :security_permissions, join_table: :security_groups_security_permissions }])
  #     find_with_association(:programs, 123, sub_tables: [{ sub_table: :program_functions },
  #                                                        { sub_table: :users, uses_join_table: true, active_only: true, columns: [:id, :user_name] }])
  #
  # Each Hash in the parent_tables array must include:
  # parent_table: Symbol - If no :columns array provided, returns all columns.
  #
  # Optional keys:
  # columns: Array of Symbols - one for each desired column. If not present, all columns are returned
  # flatten_columns: Hash of Symbol => Symbol - key is the column in the parent and value is the new name to be used on the entity.
  # foreign_key: Symbol - name of the foreign key in the table that joins to the parent table's id column.
  #
  # examples:
  #     find_with_association(:programs, prog_id, parent_tables: [{ parent_table: :functional_areas, columns: [:functional_area_name] }])
  #
  # Each Hash in the lookup_functions array must include:
  # function: Symbol - the name of the function to call.
  # args: Array of Symbols for values from the main table or of literals to be used as arguments for the function.
  # col_name: Symbol - the name to be used for the value that the function returns.
  #
  # examples:
  #     find_with_association(:customers, 123, lookup_functions: [{ function: :fn_party_role_name, args: [:party_role_id], col_name: :customer_name }])
  #
  # @param table_name [Symbol] the db table name.
  # @param id [Integer] the id of the row.
  # @param sub_tables [Array] the rules for how to find associated rows.
  # @param parent_tables [Array] the rules for how to find associated parent values.
  # @param lookup_functions [Array] the rules for how to find values via SQL functions (e.g. party_name)
  # @param wrapper [Class, nil] the class of the object to return.
  # @return [Object, nil, Hash] the row wrapped in a new wrapper object or as a Hash.
  def find_with_association(table_name, id, sub_tables: [], parent_tables: [], lookup_functions: [], wrapper: nil) # rubocop:disable Metrics/ParameterLists
    BaseRepoAssocationFinder.new(table_name, id, sub_tables: sub_tables, parent_tables: parent_tables, lookup_functions: lookup_functions, wrapper: wrapper).call
  end

  # Create a record.
  #
  # @param table_name [Symbol] the db table name.
  # @param attrs [Hash, OpenStruct] the fields and their values.
  # @return [Integer] the id of the new record.
  def create(table_name, attrs)
    DB[table_name].insert(attrs.to_h)
  end

  # Update a record.
  #
  # @param table_name [Symbol] the db table name.
  # @param id [Integer] the id of the record.
  # @param attrs [Hash, OpenStruct] the fields and their values.
  def update(table_name, id, attrs)
    DB[table_name].where(id: id).update(attrs.to_h)
  end

  # Delete a record.
  #
  # @param table_name [Symbol] the db table name.
  # @param id [Integer] the id of the record.
  def delete(table_name, id)
    DB[table_name].where(id: id).delete
  end

  # Deactivate a record.
  # Sets the +active+ column to false.
  #
  # @param table_name [Symbol] the db table name.
  # @param id [Integer] the id of the record.
  def deactivate(table_name, id)
    DB[table_name].where(id: id).update(active: false)
  end

  # Run a query returning an array of values from the first column.
  #
  # @param query [String] the SQL query to run.
  # @return [Array] the values from the first column of each row.
  def select_values(query)
    DB[query].select_map
  end

  # Get a list of values from the +master_lists+ table for a particular +list_type+.
  #
  # @param list_type [string] the list type to return.
  # @return [Array] all master_list items for the given +list_type+.
  def master_list_values(list_type)
    DB[:master_lists].where(list_type: list_type).order(:description).select_map(:description)
  end

  # Helper to convert a Ruby Hash into a value that postgresql will understand.
  #
  # @param hash [Hash] the hash to convert.
  # @return [Sequel::Postgres::JSONHash] JSON version of the Hash.
  def hash_for_jsonb_col(hash)
    return nil if hash.nil?

    Sequel.pg_jsonb(hash)
  end

  # Helper to convert a Ruby Array into a value that postgresql will understand.
  #
  # @param arr [Array] the array to convert.
  # @return [Sequel::Postgres::PGArray] Postgres version of the Array.
  def array_for_db_col(arr)
    return nil if arr.nil?

    Sequel.pg_array(arr)
  end

  # Helper to convert rows of records to a Hash that can be used for optgroups in a select.
  # Pass the records, and field names for the group, label and value elements.
  #
  # @param recs [Array] the records to process - an array of Hashes.
  # @param group_name [Symbol, String] the column with values to group by.
  # @param label [Symbol, String] the column to display as a label in a select.
  # @param value [Symbol, String] the column to act as the value in a select. Defaults to the same as the label.
  #
  # Example
  #    recs = [{type: 'A', sub: 'B', id: 1},
  #            {type: 'A', sub: 'C', id: 2},
  #            {type: 'B', sub: 'D', id: 4},
  #            {type: 'A', sub: 'E', id: 7}]
  #    optgroup_array(recs, :type, :sub, :id)
  #    # => { 'A' => [['B', 1], ['C', 2], ['E', 7]], 'B' => [['D', 4]] }
  def optgroup_array(recs, group_name, label, value = label)
    Hash[recs.map { |r| [r[group_name], r[label], r[value]] }.group_by(&:first).map { |k, v| [k, v.map { |i| [i[1], i[2]] }] }]
  end

  # Log the context of a transaction. Useful for joining to logged_actions table which has no context.
  #
  # @param user_name [String] the current user's name.
  # @param context [String] more context about what led to the action.
  # @param route_url [String] the application route that led to the transaction.
  def log_action(user_name: nil, context: nil, route_url: nil)
    DB[Sequel[:audit][:logged_action_details]].insert(user_name: user_name,
                                                      context: context,
                                                      route_url: route_url)
  end

  # Log the status of a record.
  #
  # @param table_name [String] the name of the table.
  # @param id [Integer] the id of the record with the changed status.
  # @param status [String] the status to be logged.
  # @param comment [String] extra information about the status change.
  # @param user_name [String] the current user's name.
  def log_status(table_name, id, status, comment: nil, user_name: nil) # rubocop:disable Metrics/AbcSize
    # 1. UPSERT the current status.
    DB[Sequel[:audit][:current_statuses]].insert_conflict(target: %i[table_name row_data_id],
                                                          update: {
                                                            user_name: Sequel[:excluded][:user_name],
                                                            row_data_id: Sequel[:excluded][:row_data_id],
                                                            status: Sequel[:excluded][:status],
                                                            comment: Sequel[:excluded][:comment],
                                                            transaction_id: Sequel.function(:txid_current),
                                                            action_tstamp_tx: Time.now
                                                          }).insert(user_name: user_name,
                                                                    table_name: table_name.to_s,
                                                                    row_data_id: id,
                                                                    status: status.upcase,
                                                                    comment: comment)

    # 2. INSERT into log.
    DB[Sequel[:audit][:status_logs]].insert(user_name: user_name,
                                            table_name: table_name.to_s,
                                            row_data_id: id,
                                            status: status.upcase,
                                            comment: comment)
  end

  # Log the status of several records.
  #
  # @param table_name [String] the name of the table.
  # @param in_ids [Array/Integer] the ids of the records with the changed status.
  # @param status [String] the status to be logged.
  # @param comment [String] extra information about the status change.
  # @param user_name [String] the current user's name.
  def log_multiple_statuses(table_name, in_ids, status, comment: nil, user_name: nil) # rubocop:disable Metrics/AbcSize
    ids = Array(in_ids)

    ids.each do |id|
      DB[Sequel[:audit][:current_statuses]].insert_conflict(target: %i[table_name row_data_id],
                                                            update: {
                                                              user_name: Sequel[:excluded][:user_name],
                                                              row_data_id: Sequel[:excluded][:row_data_id],
                                                              status: Sequel[:excluded][:status],
                                                              comment: Sequel[:excluded][:comment],
                                                              transaction_id: Sequel.function(:txid_current),
                                                              action_tstamp_tx: Time.now
                                                            }).insert(user_name: user_name,
                                                                      table_name: table_name.to_s,
                                                                      row_data_id: id,
                                                                      status: status.upcase,
                                                                      comment: comment)
    end

    items = []
    ids.each do |id|
      items << { user_name: user_name,
                 table_name: table_name.to_s,
                 row_data_id: id,
                 status: status.upcase,
                 comment: comment }
    end
    DB[Sequel[:audit][:status_logs]].multi_insert(items)
  end

  # Update a row with the next document sequence number.
  #
  # Gets DocumentSequence to return the update SQL to run.
  #
  # @param document_name [string] the document name (key to document sequence hash)
  # @param id [integer] the id of the row to be updated.
  # @return [void]
  def update_with_document_number(document_name, id)
    doc_seq = DocumentSequence.new(document_name)
    # check SQL from DS - is doc non-null????
    DB[doc_seq.next_sequence_update_sql(id)].update
  end

  # Run a query returning an array of column names and an array of data.
  # - useful for quickly passing to a Table renderer.
  #
  # @param query [string] the SQL query (with '?' placeholders for parameters)
  # @param args [nil, array] any parameters to apply to the query.
  def cols_and_rows_from_query(query, *args)
    dataset = DB[query, *args]
    [dataset.columns, dataset.all]
  end

  def self.inherited(klass)
    klass.extend(MethodBuilder)
  end

  private

  def make_order(dataset, sel_options)
    if sel_options[:desc]
      dataset.order_by(Sequel.desc(sel_options[:order_by]))
    else
      dataset.order_by(sel_options[:order_by])
    end
  end

  def select_single(dataset, value_name)
    dataset.select(value_name).map { |rec| rec[value_name] }
  end

  def select_two(dataset, label_name, value_name)
    if label_name.is_a?(Array)
      dataset.select(*label_name, value_name).map { |rec| [label_name.map { |nm| rec[nm] }.join(' - '), rec[value_name]] }
    else
      dataset.select(label_name, value_name).map { |rec| [rec[label_name], rec[value_name]] }
    end
  end
end

module MethodBuilder
  # Define a +for_select_table_name+ method in a repo.
  # The method returns an array of values for use in e.g. a select dropdown.
  #
  # Options:
  # alias: String
  # - If present, will be named +for_select_alias+ instead of +for_select_table_name+.
  # label: String or Array
  # - The display column. Defaults to the value column. If an Array, will display each column separated by ' - '
  # value: String
  # - The value column. Required.
  # order_by: String
  # - The column to order by.
  # desc: Boolean
  # - Use descending order if this option is present and truthy.
  # no_activity_check: Boolean
  # - Set to true if this table does not have an +active+ column,
  #   or to return inactive records as well as active ones.
  def build_for_select(table_name, options = {}) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/AbcSize
    define_method(:"for_select_#{options[:alias] || table_name}") do |opts = {}|
      dataset = DB[table_name]
      dataset = make_order(dataset, options) if options[:order_by]
      dataset = dataset.where(:active) unless options[:no_active_check]
      dataset = dataset.where(opts[:where]) if opts[:where]
      lbl = options[:label] || options[:value]
      val = options[:value]
      lbl == val ? select_single(dataset, val) : select_two(dataset, lbl, val)
    end
  end

  # Define a +for_select_inactive_table_name+ method in a repo.
  # The method returns an array of values from inactive rows for use in e.g. a select dropdown's +disabled_options+.
  #
  # Options:
  # alias: String
  # - If present, will be named +for_select_alias+ instead of +for_select_table_name+.
  # label: String or Array
  # - The display column. Defaults to the value column. If an Array, will display each column separated by ' - '
  # value: String
  # - The value column. Required.
  def build_inactive_select(table_name, options = {})
    define_method(:"for_select_inactive_#{options[:alias] || table_name}") do
      dataset = DB[table_name].exclude(:active)
      lbl = options[:label] || options[:value]
      val = options[:value]
      lbl == val ? select_single(dataset, val) : select_two(dataset, lbl, val)
    end
  end

  # Define CRUD methods for a table in a repo.
  #
  # Call like this: +crud_calls_for+ :table_name.
  #
  # This creates find_name, create_name, update_name and delete_name methods for the repo.
  # There are a few optional params allowed.
  #
  #     crud_calls_for :table_name, name: :table, wrapper: Table
  #
  # This produces the following methods:
  #
  #     find_table(id)
  #     create_table(attrs)
  #     update_table(id, attrs)
  #     delete_table(id)
  #
  # Options:
  # name: String
  # - Change the name portion of the method. default: table_name.
  # wrapper: Class
  # - The wrapper class. If not provided, there will be no +find_+ method.
  # exclude: Array
  # - A list of symbols to exclude (:create, :update, :delete)
  # schema: Symbol
  # - The schema to which the table belongs if not "public".
  def crud_calls_for(table_name, options = {}) # rubocop:disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Metrics/AbcSize
    name    = options[:name] || table_name
    wrapper = options[:wrapper]
    skip    = options[:exclude] || []

    table_with_schema = options[:schema] ? Sequel[options[:schema]][table_name] : table_name
    raise ArgumentError, "Crud calls for: Table #{table_name} does not exist" unless DB.table_exists?(table_with_schema)

    unless wrapper.nil?
      raise ArgumentError, 'Crud calls for: Wrapper not defined' unless wrapper.is_a?(Class)

      define_method(:"find_#{name}") do |id|
        find(table_with_schema, wrapper, id)
      end
    end

    unless skip.include?(:create)
      define_method(:"create_#{name}") do |attrs|
        create(table_with_schema, attrs)
      end
    end

    unless skip.include?(:update)
      define_method(:"update_#{name}") do |id, attrs|
        update(table_with_schema, id, attrs)
      end
    end

    return if skip.include?(:delete)

    define_method(:"delete_#{name}") do |id|
      delete(table_with_schema, id)
    end
  end
end
