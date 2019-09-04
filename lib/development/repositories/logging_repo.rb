# frozen_string_literal: true

module DevelopmentApp
  class LoggingRepo < BaseRepo
    crud_calls_for :logged_action_details, name: :logged_action_detail, wrapper: LoggedActionDetail, schema: :audit

    def find_logged_action_hash(id)
      where_hash(Sequel[:audit][:logged_actions], event_id: id)
    end

    def find_logged_action_hash_from_status_log(id)
      status = where_hash(Sequel[:audit][:status_logs], id: id)
      where_hash(Sequel[:audit][:logged_actions],
                 table_name: status[:table_name],
                 action_tstamp_tx: status[:action_tstamp_tx],
                 row_data_id: status[:row_data_id],
                 transaction_id: status[:transaction_id])
    end

    def find_logged_action(id)
      hash = find_logged_action_hash(id)
      return nil if hash.nil?

      LoggedAction.new(hash)
    end

    def logged_actions_for_id(table_name, id)
      query = <<~SQL
        SELECT a.event_id, a.action_tstamp_tx,
         CASE a.action WHEN 'I' THEN 'INS' WHEN 'U' THEN 'UPD'
          WHEN 'D' THEN 'DEL' ELSE 'TRUNC' END AS action,
         l.user_name, l.context, l.route_url,
         a.statement_only, a.row_data, a.changed_fields,
         ROW_NUMBER() OVER() + 1 AS id
        FROM audit.logged_actions a
        LEFT OUTER JOIN audit.logged_action_details l ON l.transaction_id = a.transaction_id AND l.action_tstamp_tx = a.action_tstamp_tx
        WHERE a.table_name = '#{table_name}'
          AND a.row_data_id = #{id}
        ORDER BY a.action_tstamp_tx DESC
      SQL
      DB[query].all
    end

    def clear_audit_trail(table_name, id)
      DB[Sequel[:audit][:logged_actions]].where(table_name: table_name, row_data_id: id).delete
    end

    def clear_audit_trail_keeping_latest(table_name, id)
      max_id = DB[Sequel[:audit][:logged_actions]].where(table_name: table_name, row_data_id: id).max(:event_id)
      DB[Sequel[:audit][:logged_actions]].where(table_name: table_name, row_data_id: id).exclude(event_id: max_id).delete
    end

    # Write out a dump of information for later inspection.
    def log_infodump(keyname, key, description, information)
      dir = File.join(ENV['ROOT'], 'log', 'infodump')
      Dir.mkdir(dir) unless Dir.exist?(dir)
      fn = File.join(dir, "#{keyname}_#{key}_#{Time.now.strftime('%Y_%m_%d_%H_%M_%S')}_#{description}.log")
      File.open(fn, 'w') { |f| f.puts information }
    end
  end
end
