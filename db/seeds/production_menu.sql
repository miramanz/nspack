-- FUNCTIONAL AREA Production
INSERT INTO functional_areas (functional_area_name, rmd_menu)
VALUES ('Production', false);


-- PROGRAM: Resources
INSERT INTO programs (program_name, program_sequence, functional_area_id)
VALUES ('Resources', 1,
        (SELECT id FROM functional_areas WHERE functional_area_name = 'Production'));

-- LINK program to webapp
INSERT INTO programs_webapps (program_id, webapp)
VALUES ((SELECT id FROM programs
                   WHERE program_name = 'Resources'
                     AND functional_area_id = (SELECT id
                                               FROM functional_areas
                                               WHERE functional_area_name = 'Production')),
                                               'Nspack');


-- PROGRAM FUNCTION Plant Resources
INSERT INTO program_functions (program_id, program_function_name, url, program_function_sequence,
                               group_name, restricted_user_access, show_in_iframe)
VALUES ((SELECT id FROM programs WHERE program_name = 'Resources'
          AND functional_area_id = (SELECT id FROM functional_areas
                                    WHERE functional_area_name = 'Production')),
        'Plant Resources',
        '/list/plant_resources',
        2,
        NULL,
        false,
        false);


-- PROGRAM FUNCTION Plant resource types
INSERT INTO program_functions (program_id, program_function_name, url, program_function_sequence,
                               group_name, restricted_user_access, show_in_iframe)
VALUES ((SELECT id FROM programs WHERE program_name = 'Resources'
          AND functional_area_id = (SELECT id FROM functional_areas
                                    WHERE functional_area_name = 'Production')),
        'Plant resource types',
        '/list/plant_resource_types',
        2,
        'Resource Types',
        false,
        false);


-- PROGRAM FUNCTION System_resource_types
INSERT INTO program_functions (program_id, program_function_name, url, program_function_sequence,
                               group_name, restricted_user_access, show_in_iframe)
VALUES ((SELECT id FROM programs WHERE program_name = 'Resources'
          AND functional_area_id = (SELECT id FROM functional_areas
                                    WHERE functional_area_name = 'Production')),
        'System_resource_types',
        '/list/system_resource_types',
        3,
        'Resource Types',
        false,
        false);
