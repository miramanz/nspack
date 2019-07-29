
INSERT INTO functional_areas (functional_area_name)
VALUES ('Masterfiles');

-- PARTIES
INSERT INTO programs (program_name, program_sequence, functional_area_id)
VALUES ('Parties', 1, (SELECT id FROM functional_areas WHERE functional_area_name = 'Masterfiles'));

INSERT INTO programs_webapps (program_id, webapp)
VALUES ((SELECT id FROM programs WHERE program_name = 'Parties' AND functional_area_id = (SELECT id FROM functional_areas WHERE functional_area_name = 'Masterfiles')), 'Nspack');

-- Grouped in Contact Details
INSERT INTO program_functions (program_id, program_function_name, group_name, url, program_function_sequence)
VALUES ((SELECT id FROM programs WHERE program_name = 'Parties'
                                       AND functional_area_id = (SELECT id FROM functional_areas
WHERE functional_area_name = 'Masterfiles')),
        'Addresses', 'Contact Details', '/list/addresses', 2);

INSERT INTO program_functions (program_id, program_function_name, group_name, url, program_function_sequence)
VALUES ((SELECT id FROM programs WHERE program_name = 'Parties'
                                       AND functional_area_id = (SELECT id FROM functional_areas
WHERE functional_area_name = 'Masterfiles')),
        'Contact methods', 'Contact Details', '/list/contact_methods', 2);

-- Not Grouped
INSERT INTO program_functions (program_id, program_function_name, url, program_function_sequence)
VALUES ((SELECT id FROM programs WHERE program_name = 'Parties'
                                       AND functional_area_id = (SELECT id FROM functional_areas
WHERE functional_area_name = 'Masterfiles')),
        'Organizations', '/list/organizations', 2);

INSERT INTO program_functions (program_id, program_function_name, url, program_function_sequence)
VALUES ((SELECT id FROM programs WHERE program_name = 'Parties'
                                       AND functional_area_id = (SELECT id FROM functional_areas
WHERE functional_area_name = 'Masterfiles')),
        'People', '/list/people', 2);


-- FRUIT
INSERT INTO programs (program_name, program_sequence, functional_area_id)
VALUES ('Fruit', 2, (SELECT id FROM functional_areas WHERE functional_area_name = 'Masterfiles'));

INSERT INTO programs_webapps (program_id, webapp)
VALUES ((SELECT id FROM programs WHERE program_name = 'Fruit' AND functional_area_id = (SELECT id FROM functional_areas WHERE functional_area_name = 'Masterfiles')), 'Nspack');

-- Grouped in Commodities
INSERT INTO program_functions (program_id, program_function_name, group_name, url, program_function_sequence)
VALUES ((SELECT id FROM programs WHERE program_name = 'Fruit'
                                       AND functional_area_id = (SELECT id FROM functional_areas
WHERE functional_area_name = 'Masterfiles')),
        'Groups', 'Commodities', '/list/commodity_groups', 1);

INSERT INTO program_functions (program_id, program_function_name, group_name, url, program_function_sequence)
VALUES ((SELECT id FROM programs WHERE program_name = 'Fruit'
                                       AND functional_area_id = (SELECT id FROM functional_areas
WHERE functional_area_name = 'Masterfiles')),
        'Commodities', 'Commodities', '/list/commodities', 2);

-- Grouped in Cultivars
INSERT INTO program_functions (program_id, program_function_name, url, program_function_sequence, group_name)
VALUES ((SELECT id FROM programs WHERE program_name = 'Fruit'
                                       AND functional_area_id = (SELECT id FROM functional_areas
WHERE functional_area_name = 'Masterfiles')),
        'Groups', '/list/cultivar_groups', 2, 'Cultivars');

INSERT INTO program_functions (program_id, program_function_name, url, program_function_sequence, group_name)
VALUES ((SELECT id FROM programs WHERE program_name = 'Fruit'
                                       AND functional_area_id = (SELECT id FROM functional_areas
WHERE functional_area_name = 'Masterfiles')),
        'Cultivars', '/list/cultivars', 2, 'Cultivars');

INSERT INTO program_functions (program_id, program_function_name, url, program_function_sequence, group_name)
VALUES ((SELECT id FROM programs WHERE program_name = 'Fruit'
                                       AND functional_area_id = (SELECT id FROM functional_areas
WHERE functional_area_name = 'Masterfiles')),
        'Marketing varieties', '/list/marketing_varieties', 2, 'Cultivars');

-- Grouped in Pack codes
INSERT INTO program_functions (program_id, program_function_name, url, program_function_sequence, group_name)
VALUES ((SELECT id FROM programs WHERE program_name = 'Fruit'
                                       AND functional_area_id = (SELECT id FROM functional_areas
WHERE functional_area_name = 'Masterfiles')),
        'Basic', '/list/basic_pack_codes', 2, 'Pack codes');

INSERT INTO program_functions (program_id, program_function_name, url, program_function_sequence, group_name)
VALUES ((SELECT id FROM programs WHERE program_name = 'Fruit'
                                       AND functional_area_id = (SELECT id FROM functional_areas
WHERE functional_area_name = 'Masterfiles')),
        'Standard', '/list/standard_pack_codes', 2, 'Pack codes');

-- Not Grouped
INSERT INTO program_functions (program_id, program_function_name, url, program_function_sequence)
VALUES ((SELECT id FROM programs WHERE program_name = 'Fruit'
                                       AND functional_area_id = (SELECT id FROM functional_areas
WHERE functional_area_name = 'Masterfiles')),
        'Std Fruit Size Counts', '/list/std_fruit_size_counts', 2);

-- RMT Classes
INSERT INTO program_functions (program_id, program_function_name, url, program_function_sequence)
VALUES ((SELECT id FROM programs WHERE program_name = 'Fruit'
         AND functional_area_id = (SELECT id FROM functional_areas
                                   WHERE functional_area_name = 'Masterfiles')),
         'RMT Classes', '/list/rmt_classes', 2);

-- TARGET MARKETS
INSERT INTO programs (program_name, program_sequence, functional_area_id)
VALUES ('Target Markets', 3, (SELECT id FROM functional_areas WHERE functional_area_name = 'Masterfiles'));

INSERT INTO programs_webapps (program_id, webapp)
VALUES ((SELECT id FROM programs WHERE program_name = 'Target Markets' AND functional_area_id = (SELECT id FROM functional_areas WHERE functional_area_name = 'Masterfiles')), 'Nspack');

-- Grouped in Target Markets
INSERT INTO program_functions (program_id, program_function_name, url, program_function_sequence, group_name)
VALUES ((SELECT id FROM programs WHERE program_name = 'Target Markets'
                                       AND functional_area_id = (SELECT id FROM functional_areas
WHERE functional_area_name = 'Masterfiles')),
        'Types', '/list/target_market_group_types', 2, 'Target markets');

INSERT INTO program_functions (program_id, program_function_name, url, program_function_sequence, group_name)
VALUES ((SELECT id FROM programs WHERE program_name = 'Target Markets'
                                       AND functional_area_id = (SELECT id FROM functional_areas
WHERE functional_area_name = 'Masterfiles')),
        'Groups', '/list/target_market_groups', 2, 'Target markets');

INSERT INTO program_functions (program_id, program_function_name, url, program_function_sequence, group_name)
VALUES ((SELECT id FROM programs WHERE program_name = 'Target Markets'
                                       AND functional_area_id = (SELECT id FROM functional_areas
WHERE functional_area_name = 'Masterfiles')),
        'Target markets', '/list/target_markets', 2, 'Target markets');

--Grouped in Destination
INSERT INTO program_functions (program_id, program_function_name, url, program_function_sequence, group_name)
VALUES ((SELECT id FROM programs WHERE program_name = 'Target Markets'
                                       AND functional_area_id = (SELECT id FROM functional_areas
WHERE functional_area_name = 'Masterfiles')),
        'Regions', '/list/destination_regions', 2, 'Destination');

INSERT INTO program_functions (program_id, program_function_name, url, program_function_sequence, group_name)
VALUES ((SELECT id FROM programs WHERE program_name = 'Target Markets'
                                       AND functional_area_id = (SELECT id FROM functional_areas
WHERE functional_area_name = 'Masterfiles')),
        'Countries', '/list/destination_countries', 2, 'Destination');

INSERT INTO program_functions (program_id, program_function_name, url, program_function_sequence, group_name)
VALUES ((SELECT id FROM programs WHERE program_name = 'Target Markets'
                                       AND functional_area_id = (SELECT id FROM functional_areas
WHERE functional_area_name = 'Masterfiles')),
        'Cities', '/list/destination_cities', 2, 'Destination');


-- LOCATIONS

--INSERT INTO functional_areas (functional_area_name) VALUES ('Masterfiles');

INSERT INTO programs (program_name, program_sequence, functional_area_id)
VALUES ('Locations', 1, (SELECT id FROM functional_areas
                                              WHERE functional_area_name = 'Masterfiles'));

INSERT INTO programs_webapps(program_id, webapp) VALUES (
      (SELECT id FROM programs
       WHERE program_name = 'Locations'
         AND functional_area_id = (SELECT id FROM functional_areas
                                   WHERE functional_area_name = 'Masterfiles')),
       'Nspack');

INSERT INTO program_functions (program_id, program_function_name, url, program_function_sequence)
VALUES ((SELECT id FROM programs WHERE program_name = 'Locations'
                                       AND functional_area_id = (SELECT id FROM functional_areas
WHERE functional_area_name = 'Masterfiles')),
        'Locations', '/list/locations', 2);

INSERT INTO program_functions (program_id, program_function_name, url, program_function_sequence)
VALUES ((SELECT id FROM programs WHERE program_name = 'Locations'
                                       AND functional_area_id = (SELECT id FROM functional_areas
WHERE functional_area_name = 'Masterfiles')),
        'Search Locations', '/search/locations', 2);

INSERT INTO program_functions (program_id, program_function_name, url, program_function_sequence)
VALUES ((SELECT id FROM programs WHERE program_name = 'Locations'
         AND functional_area_id = (SELECT id FROM functional_areas
                                   WHERE functional_area_name = 'Masterfiles')),
         'Assignments', '/list/location_assignments', 2);

INSERT INTO program_functions (program_id, program_function_name, url, program_function_sequence)
VALUES ((SELECT id FROM programs WHERE program_name = 'Locations'
                                       AND functional_area_id = (SELECT id FROM functional_areas
WHERE functional_area_name = 'Masterfiles')),
        'Types', '/list/location_types', 2);

INSERT INTO program_functions (program_id, program_function_name, url, program_function_sequence)
VALUES ((SELECT id FROM programs WHERE program_name = 'Locations'
                                       AND functional_area_id = (SELECT id FROM functional_areas
WHERE functional_area_name = 'Masterfiles')),
        'Storage Types', '/list/location_storage_types', 2);

INSERT INTO program_functions (program_id, program_function_name, url, program_function_sequence)
VALUES ((SELECT id FROM programs WHERE program_name = 'Locations'
                                       AND functional_area_id = (SELECT id FROM functional_areas
WHERE functional_area_name = 'Masterfiles')),
        'Storage Definitions', '/list/location_storage_definitions', 2);

INSERT INTO location_types (location_type_code, short_code) VALUES ('RECEIVING BAY', 'RB');


-- CONFIG / LABEL TEMPLATES

-- PROGRAM: Config
INSERT INTO programs (program_name, program_sequence, functional_area_id)
VALUES ('Config', 1,
        (SELECT id FROM functional_areas WHERE functional_area_name = 'Masterfiles'));

-- LINK program to webapp
INSERT INTO programs_webapps (program_id, webapp)
VALUES ((SELECT id FROM programs
                   WHERE program_name = 'Config'
                     AND functional_area_id = (SELECT id
                                               FROM functional_areas
                                               WHERE functional_area_name = 'Masterfiles')),
                                               'Nspack');


-- PROGRAM FUNCTION Label_templates
INSERT INTO program_functions (program_id, program_function_name, url, program_function_sequence,
                               group_name, restricted_user_access, show_in_iframe)
VALUES ((SELECT id FROM programs WHERE program_name = 'Config'
          AND functional_area_id = (SELECT id FROM functional_areas
                                    WHERE functional_area_name = 'Masterfiles')),
        'Label_templates',
        '/list/label_templates',
        2,
        NULL,
        false,
        false);

-- PROGRAM calendar
INSERT INTO programs (program_name, program_sequence, functional_area_id)
VALUES ('Calendar', 1, (SELECT id FROM functional_areas
                                              WHERE functional_area_name = 'Masterfiles'));

INSERT INTO programs_webapps(program_id, webapp) VALUES (
      (SELECT id FROM programs
       WHERE program_name = 'Calendar'
         AND functional_area_id = (SELECT id FROM functional_areas
                                   WHERE functional_area_name = 'Masterfiles')),
       'Nspack');

INSERT INTO program_functions (program_id, program_function_name, url, program_function_sequence)
VALUES ((SELECT id FROM programs WHERE program_name = 'Calendar'
         AND functional_area_id = (SELECT id FROM functional_areas
                                   WHERE functional_area_name = 'Masterfiles')),
         'Season_groups', '/list/season_groups', 2);

INSERT INTO program_functions (program_id, program_function_name, url, program_function_sequence)
VALUES ((SELECT id FROM programs WHERE program_name = 'Calendar'
         AND functional_area_id = (SELECT id FROM functional_areas
                                   WHERE functional_area_name = 'Masterfiles')),
         'Seasons', '/list/seasons', 2);

-- PROGRAM raw_materials
INSERT INTO programs (program_name, program_sequence, functional_area_id)
VALUES ('Raw Materials', 1, (SELECT id FROM functional_areas
                                              WHERE functional_area_name = 'Masterfiles'));

INSERT INTO programs_webapps(program_id, webapp) VALUES (
      (SELECT id FROM programs
       WHERE program_name = 'Raw Materials'
         AND functional_area_id = (SELECT id FROM functional_areas
                                   WHERE functional_area_name = 'Masterfiles')),
       'Nspack');

-- LIST menu item
INSERT INTO program_functions (program_id, program_function_name, url, program_function_sequence)
VALUES ((SELECT id FROM programs WHERE program_name = 'Raw Materials'
         AND functional_area_id = (SELECT id FROM functional_areas
                                   WHERE functional_area_name = 'Masterfiles')),
         'Rmt_delivery_destinations', '/list/rmt_delivery_destinations', 2);



-- PROGRAM: Farms
INSERT INTO programs (program_name, program_sequence, functional_area_id)
VALUES ('Farms', 1,
        (SELECT id FROM functional_areas WHERE functional_area_name = 'Masterfiles'));

-- LINK program to webapp
INSERT INTO programs_webapps (program_id, webapp)
VALUES ((SELECT id FROM programs
                   WHERE program_name = 'Farms'
                     AND functional_area_id = (SELECT id
                                               FROM functional_areas
                                               WHERE functional_area_name = 'Masterfiles')),
                                               'Nspack');


-- PROGRAM FUNCTION Production_regions
INSERT INTO program_functions (program_id, program_function_name, url, program_function_sequence,
                               group_name, restricted_user_access, show_in_iframe)
VALUES ((SELECT id FROM programs WHERE program_name = 'Farms'
          AND functional_area_id = (SELECT id FROM functional_areas
                                    WHERE functional_area_name = 'Masterfiles')),
        'Production_regions',
        '/list/production_regions',
        2,
        NULL,
        false,
        false);

-- Farms
-- LIST menu item
INSERT INTO program_functions (program_id, program_function_name, url, program_function_sequence)
VALUES ((SELECT id FROM programs WHERE program_name = 'Farms'
         AND functional_area_id = (SELECT id FROM functional_areas
                                   WHERE functional_area_name = 'Masterfiles')),
         'Farm_groups', '/list/farm_groups', 2);

INSERT INTO program_functions (program_id, program_function_name, url, program_function_sequence)
VALUES ((SELECT id FROM programs WHERE program_name = 'Farms'
         AND functional_area_id = (SELECT id FROM functional_areas
                                   WHERE functional_area_name = 'Masterfiles')),
         'Farms', '/list/farms', 2);

INSERT INTO program_functions (program_id, program_function_name, url, program_function_sequence)
VALUES ((SELECT id FROM programs WHERE program_name = 'Farms'
         AND functional_area_id = (SELECT id FROM functional_areas
                                   WHERE functional_area_name = 'Masterfiles')),
         'Orchards', '/list/orchards', 2);

INSERT INTO program_functions (program_id, program_function_name, url, program_function_sequence)
VALUES ((SELECT id FROM programs WHERE program_name = 'Farms'
         AND functional_area_id = (SELECT id FROM functional_areas
                                   WHERE functional_area_name = 'Masterfiles')),
         'Pucs', '/list/pucs', 2);