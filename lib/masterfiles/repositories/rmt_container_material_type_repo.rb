# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
# rubocop:disable Metrics/AbcSize

module MasterfilesApp
  class RmtContainerMaterialTypeRepo < BaseRepo
    build_for_select :rmt_container_material_types,
                     label: :container_material_type_code,
                     value: :id,
                     order_by: :container_material_type_code
    build_inactive_select :rmt_container_material_types,
                          label: :container_material_type_code,
                          value: :id,
                          order_by: :container_material_type_code

    crud_calls_for :rmt_container_material_types, name: :rmt_container_material_type, wrapper: RmtContainerMaterialType

    def for_select_party_roles
      DB[:party_roles].select(:id, Sequel.function(:fn_rmt_container_owners, :id)).map { |r| [r[:fn_rmt_container_owners], r[:id]] }
    end

    def find_rmt_container_material_type(id)
      hash = DB[:rmt_container_material_types].where(id: id).first
      return nil if hash.nil?

      hash[:party_role_ids] = party_role_ids(hash[:id])
      hash[:container_material_owners] = container_material_owners(hash[:id])
      RmtContainerMaterialType.new(hash)
    end

    def party_role_ids(rmt_container_material_type_id)
      DB[:party_roles].where(id: DB[:rmt_container_material_owners].where(rmt_container_material_type_id: rmt_container_material_type_id).select(:rmt_material_owner_party_role_id)).select(:id, Sequel.function(:fn_rmt_container_owners, :id)).map { |r| r[:id] }
    end

    def container_material_owners(rmt_container_material_type_id)
      # DB[:organizations].where(id: DB[:party_roles].where(id: DB[:rmt_container_material_owners].where(rmt_container_material_type_id: rmt_container_material_type_id).select(:rmt_material_owner_party_role_id)).select(:organization_id)).map { |r| r[:short_description] }
      DB[:party_roles].where(id: DB[:rmt_container_material_owners].where(rmt_container_material_type_id: rmt_container_material_type_id).select(:rmt_material_owner_party_role_id)).select(:id, Sequel.function(:fn_rmt_container_owners, :id)).map { |r| r[:fn_rmt_container_owners] }
    end

    def get_current_rmt_material_container_owners(rmt_container_material_type_id)
      DB[:rmt_container_material_owners].where(rmt_container_material_type_id: rmt_container_material_type_id)
    end

    def delete_rmt_material_container_owners(rmt_material_container_owners, party_role_ids)
      rmt_material_container_owners.where(rmt_material_owner_party_role_id: party_role_ids).delete
    end

    def create_rmt_material_container_owner(rmt_container_material_type_id, rmt_material_owner_party_role_id)
      DB[:rmt_container_material_owners].insert(rmt_container_material_type_id: rmt_container_material_type_id, rmt_material_owner_party_role_id: rmt_material_owner_party_role_id)
    end

    def delete_rmt_container_material_type(id)
      DB[:rmt_container_material_owners].where(rmt_container_material_type_id: id).delete
      DB[:rmt_container_material_types].where(id: id).delete
    end

    def create_rmt_container_material_type(attrs)
      params = attrs.to_h
      party_role_ids ||= []
      # return { error: { roles: ['You did not choose a party role'] } } if party_role_ids.empty?

      rmt_container_material_type_id = DB[:rmt_container_material_types].insert(params)
      party_role_ids.each do |pr_id|
        DB[:rmt_container_material_owners].insert(rmt_container_material_type_id: rmt_container_material_type_id,
                                                  rmt_material_owner_party_role_id: pr_id)
      end
      { id: rmt_container_material_type_id }
    end

  end
end
