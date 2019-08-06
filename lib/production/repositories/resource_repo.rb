# frozen_string_literal: true

module ProductionApp
  class ResourceRepo < BaseRepo
    build_for_select :plant_resource_types,
                     label: :plant_resource_type_code,
                     value: :id,
                     order_by: :plant_resource_type_code
    build_inactive_select :plant_resource_types,
                          label: :plant_resource_type_code,
                          value: :id,
                          order_by: :plant_resource_type_code
    build_for_select :plant_resources,
                     label: :plant_resource_code,
                     value: :id,
                     order_by: :plant_resource_code
    build_inactive_select :plant_resources,
                          label: :plant_resource_code,
                          value: :id,
                          order_by: :plant_resource_code
    build_for_select :system_resource_types,
                     label: :system_resource_type_code,
                     value: :id,
                     order_by: :system_resource_type_code
    build_inactive_select :system_resource_types,
                          label: :system_resource_type_code,
                          value: :id,
                          order_by: :system_resource_type_code

    crud_calls_for :plant_resource_types, name: :plant_resource_type, wrapper: PlantResourceType
    crud_calls_for :plant_resources, name: :plant_resource, wrapper: PlantResource
    crud_calls_for :system_resource_types, name: :system_resource_type, wrapper: SystemResourceType

    def for_select_plant_resource_types(plant_resource_type_code)
      possible_codes = if plant_resource_type_code.nil?
                         Crossbeams::Config::ResourceDefinitions::ROOT_PLANT_RESOURCE_TYPES
                       else
                         Crossbeams::Config::ResourceDefinitions::PLANT_RESOURCE_RULES[plant_resource_type_code][:allowed_children]
                       end
      DB[:plant_resource_types].where(plant_resource_type_code: possible_codes).select_map(%i[plant_resource_type_code id])
    end

    def create_plant_resource_type(attrs)
      new_attrs = attrs.to_h
      new_attrs[:attribute_rules] = hash_for_jsonb_col(attrs[:attribute_rules])
      new_attrs[:behaviour_rules] = hash_for_jsonb_col(attrs[:behaviour_rules])
      create(:plant_resource_types, new_attrs)
    end

    def create_root_plant_resource(params)
      id = create_plant_resource(params)
      DB[:tree_plant_resources].insert(ancestor_plant_resource_id: id,
                                       descendant_plant_resource_id: id,
                                       path_length: 0)
      id
    end

    def create_child_plant_resource(parent_id, res)
      id = create_plant_resource(res)
      DB.execute(<<~SQL)
        INSERT INTO tree_plant_resources (ancestor_plant_resource_id, descendant_plant_resource_id, path_length)
        SELECT t.ancestor_plant_resource_id, #{id}, t.path_length + 1
        FROM tree_plant_resources AS t
        WHERE t.descendant_plant_resource_id = #{parent_id}
        UNION ALL
        SELECT #{id}, #{id}, 0;
      SQL
      id
    end

    def create_plant_resource(attrs)
      new_attrs = attrs.to_h
      new_attrs[:plant_resource_attributes] = hash_for_jsonb_col(attrs[:plant_resource_attributes]) if attrs.to_h[:plant_resource_attributes]
      create(:plant_resources, new_attrs)
    end

    def delete_plant_resource(id)
      DB[:tree_plant_resources].where(ancestor_plant_resource_id: id).or(descendant_plant_resource_id: id).delete
      DB[:plant_resources].where(id: id).delete
    end

    def plant_resource_type_code_for(plant_resource_id)
      DB[:plant_resources].join(:plant_resource_types, id: :plant_resource_type_id).where(Sequel[:plant_resources][:id] => plant_resource_id).get(:plant_resource_type_code)
    end
  end
end
