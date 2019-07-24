# frozen_string_literal: true

module Development
  module Generators
    module Scaffolds
      class Show # rubocop:disable Metrics/ClassLength
        def self.call(results) # rubocop:disable Metrics/AbcSize
          ui_rule = UiRules::Compiler.new(:scaffolds, :new)
          rules   = ui_rule.compile

          layout = Crossbeams::Layout::Page.build(rules) do |page| # rubocop:disable Metrics/BlockLength
            page.section do |section|
              section.add_text <<~HTML
                <p>
                  Preview of files to be generated.<br>
                  <em>Note the permissions required for program <strong>#{results[:opts].program}</strong></em>
                </p>
                <p>
                <em>If your server code is reloaded automatically, be careful of the order you press the save buttons - otherwise some code might load that depends on some other code that has not yet been saved...</em>
                </p>
              HTML
            end
            page.section do |section|
              section.caption = 'Table of Contents'
              section.hide_caption = false
              toc = [
                '<a href="#entity">Entity</a>',
                '<a href="#validation">Validation</a>',
                '<a href="#repo">Repo</a>',
                '<a href="#interactor">Interactor</a>',
                '<a href="#permissions">Permissions</a>',
                '<a href="#routes">Routes</a>',
                '<a href="#views">Views</a>',
                '<a href="#ui_rules">UI Rules</a>',
                '<a href="#tests">Tests</a>',
                '<a href="#query">Query to use in Dataminer</a>',
                '<a href="#dm_query">Dataminer Query YAML</a>',
                '<a href="#list">List YAML</a>',
                '<a href="#search">Search YAML</a>',
                '<a href="#sql">Optional SQL for inserting menu items</a>'
              ]
              toc.unshift('<a href="#applet">Applet</a>') if results[:applet]
              section.add_text("<ol><li>#{toc.join('</li><li>')}</ol>")
            end
            if results[:applet]
              page.section do |section|
                section.caption = '<a name="applet">Applet</a>'
                section.hide_caption = false
                save_snippet_form(section, results[:paths][:applet], results[:applet])
                section.add_text(results[:applet], preformatted: true, syntax: :ruby)
              end
            end
            page.section do |section|
              section.caption = '<a name="entity">Entity</a>'
              section.hide_caption = false
              save_snippet_form(section, results[:paths][:entity], results[:entity])
              section.add_text(results[:entity], syntax: :ruby)
            end
            page.section do |section|
              section.caption = '<a name="validation">Validation</a>'
              section.hide_caption = false
              save_snippet_form(section, results[:paths][:validation], results[:validation])
              section.add_text(results[:validation], syntax: :ruby)
            end
            page.section do |section|
              section.caption = '<a name="repo">Repo</a>'
              section.hide_caption = false
              save_snippet_form(section, results[:paths][:repo], results[:repo])
              section.add_text(results[:repo], preformatted: true, syntax: :ruby)
            end
            page.section do |section|
              section.caption = '<a name="interactor">Interactor</a>'
              section.hide_caption = false
              save_snippet_form(section, results[:paths][:inter], results[:inter])
              section.add_text(results[:inter], syntax: :ruby)
            end
            page.section do |section|
              section.caption = '<a name="permissions">Permissions</a>'
              section.hide_caption = false
              save_snippet_form(section, results[:paths][:permission], results[:permission])
              section.add_text(results[:permission], syntax: :ruby)
            end
            page.section do |section|
              section.caption = '<a name="routes">Routes</a>'
              section.hide_caption = false
              save_snippet_form(section, results[:paths][:route], results[:route])
              section.add_text(results[:route], syntax: :ruby)
            end
            page.section do |section|
              section.caption = '<a name="views">Views</a>'
              section.hide_caption = false
              save_snippet_form(section, results[:paths][:view][:new], results[:view][:new])
              section.add_text(results[:view][:new], syntax: :ruby)
              save_snippet_form(section, results[:paths][:view][:edit], results[:view][:edit])
              section.add_text(results[:view][:edit], syntax: :ruby)
              save_snippet_form(section, results[:paths][:view][:show], results[:view][:show])
              section.add_text(results[:view][:show], syntax: :ruby)
              save_snippet_form(section, results[:paths][:view][:complete], results[:view][:complete])
              section.add_text(results[:view][:complete], syntax: :ruby)
              save_snippet_form(section, results[:paths][:view][:approve], results[:view][:approve])
              section.add_text(results[:view][:approve], syntax: :ruby)
              save_snippet_form(section, results[:paths][:view][:reopen], results[:view][:reopen])
              section.add_text(results[:view][:reopen], syntax: :ruby)
            end
            page.section do |section|
              section.caption = '<a name="ui_rules">UI Rules</a>'
              section.hide_caption = false
              save_snippet_form(section, results[:paths][:uirule], results[:uirule])
              section.add_text(results[:uirule], syntax: :ruby)
            end
            page.section do |section|
              section.caption = '<a name="tests">Tests</a>'
              section.hide_caption = false
              save_snippet_form(section, results[:paths][:test][:factory], results[:test][:factory])
              section.add_text(results[:test][:factory], syntax: :ruby)
              save_snippet_form(section, results[:paths][:test][:interactor], results[:test][:interactor])
              section.add_text(results[:test][:interactor], syntax: :ruby)
              save_snippet_form(section, results[:paths][:test][:permission], results[:test][:permission])
              section.add_text(results[:test][:permission], syntax: :ruby)
              save_snippet_form(section, results[:paths][:test][:repo], results[:test][:repo])
              section.add_text(results[:test][:repo], syntax: :ruby)
              save_snippet_form(section, results[:paths][:test][:route], results[:test][:route])
              section.add_text(results[:test][:route], syntax: :ruby)
            end
            page.section do |section|
              section.caption = '<a name="query">Query to use in Dataminer</a>'
              section.hide_caption = false
              section.add_text(<<~HTML)
                <p>
                  The query might need tweaking - especially if there are joins.
                  Adjust it and edit the Dataminer Query.
                </p>
              HTML
              section.add_text(<<~HTML, syntax: :sql)
                -- Example of colouring some rows:
                SELECT id,
                  CASE WHEN complete THEN 'ready'       -- blue
                       WHEN approved THEN 'ok'          -- green
                       WHEN failed   THEN 'error'       -- red
                       WHEN archived THEN 'inactive'    -- grey, italic
                       WHEN busy     THEN 'inprogress'  -- purple
                       WHEN claimed  THEN 'warning'     -- orange
                  ELSE NULL                             -- black
                  END AS colour_rule
                FROM table
              HTML
              section.add_text(results[:query], syntax: :sql)
            end
            page.section do |section|
              section.caption = '<a name="dm_query">Dataminer Query YAML</a>'
              section.hide_caption = false
              save_snippet_form(section, results[:paths][:dm_query], results[:dm_query])
              section.add_text(results[:dm_query], syntax: :yaml)
            end
            page.section do |section|
              section.caption = '<a name="list">List YAML</a>'
              section.hide_caption = false
              save_snippet_form(section, results[:paths][:list], results[:list])
              section.add_text(results[:list], syntax: :yaml)
            end
            page.section do |section|
              section.caption = '<a name="search">Search YAML</a>'
              section.hide_caption = false
              save_snippet_form(section, results[:paths][:search], results[:search])
              section.add_text(results[:search], syntax: :yaml)
            end
            page.section do |section|
              section.caption = '<a name="sql">Optional SQL for inserting menu items</a>'
              section.hide_caption = false
              section.add_text(results[:menu], syntax: :sql)
            end
          end

          layout
        end

        def self.save_snippet_form(section, path, code) # rubocop:disable Metrics/AbcSize
          if !File.exist?(File.join(ENV['ROOT'], path))
            section.form do |form|
              form.form_config = {
                name: 'snippet',
                fields: {
                  path: { readonly: true },
                  value: { renderer: :hidden }
                }
              }
              form.form_object OpenStruct.new(path: path, value: Base64.encode64(code))
              form.action '/development/generators/scaffolds/save_snippet'
              form.method :update
              form.remote!
              form.add_field :path
              form.add_field :value
              form.submit_captions 'Save', 'Saving'
            end
          else
            section.add_text(path)
          end
        end

        private_class_method :save_snippet_form
      end
    end
  end
end
