module Crossbeams
  # Form for RMD (Registered Mobile Devices)
  #
  # This renders a form that is simpler than the Crossbeams::Layout form
  # specifically for RMDs using the layout_rmd view.
  class RMDForm # rubocop:disable Metrics/ClassLength
    attr_reader :form_state, :form_name, :progress, :notes, :scan_with_camera,
                :caption, :action, :button_caption, :csrf_tag

    # Create a form.
    #
    # @param form_state [Hash] state of form (errors, current values)
    # @param options (Hash) options for the form
    # @option options [String] :form_name The name of the form.
    # @option options [String] :caption The caption for the form.
    # @option options [String] :progress Any progress to display (scanned 1 of 20 etc.)
    # @option options [String] :notes Any Notes to display on the form.
    # @option options [Boolean] :scan_with_camera Should the RMD be able to use the camera to scan. Default is false.
    # @option options [String] :action The URL for the POST action.
    # @option options [String] :button_caption The submit button's caption.
    # @option options [Boolean] :reset_button Should the RMD form include a button to reset form values? Default is true.
    # @option options [Array] :step_and_total The step number and total no of steps. Optional - only prints if the caption is given.
    # @option options [Array] :links An array of hashes with { :caption, :url, :prompt (optional) } which provide links to navigate away.
    def initialize(form_state, options) # rubocop:disable Metrics/AbcSize
      @form_state = form_state
      @form_name = options.fetch(:form_name)
      @progress = options[:progress]
      @notes = options[:notes]
      @scan_with_camera = options[:scan_with_camera] == true
      @caption = options[:caption]
      @step_number, @step_count = Array(options[:step_and_total])
      @links = options[:links] || []
      @action = options.fetch(:action)
      @button_caption = options[:button_caption]
      @reset_button = options.fetch(:reset_button, true)
      @fields = []
      @csrf_tag = nil
    end

    # Add a field to the form.
    # The field will render as an input with name = FORM_NAME[FIELD_NAME]
    # and id = FORM_NAME_FIELD_NAME.
    #
    # @param name [string] the name of the form field.
    # @param label [string] the caption for the label to appear beside the input.
    # @param options (Hash) options for the field
    # @option options [Boolean] :required Is the field required? Defaults to true.
    # @option options [String] :data_type the input type. Defaults to 'text'.
    # @option options [Boolean] :allow_decimals can a data_type="number" input accept decimals?
    # @option options [String] :scan The type of barcode symbology to accept. e.g. 'key248_all' for any symbology. Omit for input that does not receive a scan result.
    # Possible values are: key248_all (any symbology), key249_3o9 (309), key250_upc (UPC), key251_ean (EAN), key252_2d (2D - QR etc)
    # @option options [Symbol] :scan_type the type of barcode to expect in the field. This must have a matching entry in AppConst::BARCODE_PRINT_RULES.
    # @return [void]
    def add_field(name, label, options) # rubocop:disable Metrics/AbcSize
      @current_field = name
      for_scan = options[:scan] ? 'Scan ' : ''
      data_type = options[:data_type] || 'text'
      required = options[:required].nil? || options[:required] ? ' required' : ''
      autofocus = autofocus_for_field(name)
      @fields << <<~HTML
        <tr#{field_error_state}><th align="left">#{label}#{field_error_message}</th>
        <td><input class="pa2#{field_error_class}" id="#{form_name}_#{name}" type="#{data_type}"#{decimal_or_int(data_type, options)} name="#{form_name}[#{name}]" placeholder="#{for_scan}#{label}"#{scan_opts(options)} value="#{form_state[name]}"#{required}#{autofocus}#{lookup_data(options)}#{submit_form(options)}>#{hidden_scan_type(name, options)}#{lookup_display(name, options)}
        </td></tr>
      HTML
    end

    # Add a select box to the form.
    # The field will render as an input with name = FORM_NAME[FIELD_NAME]
    # and id = FORM_NAME_FIELD_NAME.
    #
    # @param name [string] the name of the form field.
    # @param label [string] the caption for the label to appear beside the select.
    # @param options (Hash) options for the field
    # @option options [Boolean] :required Is the field required? Defaults to true.
    # @option options [String] :value the selected value.
    # @option options [String,Boolean] :prompt if true, display a generic prompt. If a string, display the string as prompt.
    # @option options [Array,Hash] :items the select options.
    # @return [void]
    def add_select(name, label, options = {}) # rubocop:disable Metrics/AbcSize
      @current_field = name
      required = options[:required].nil? || options[:required] ? ' required' : ''
      items = options[:items] || []
      autofocus = autofocus_for_field(name)
      value = form_state[name] || options[:value]
      @fields << <<~HTML
        <tr#{field_error_state}><th align="left">#{label}#{field_error_message}</th>
        <td><select class="pa2#{field_error_class}" id="#{form_name}_#{name}" name="#{form_name}[#{name}]" #{required}#{autofocus}>
          #{make_prompt(options[:prompt])}#{build_options(items, value)}
        </select>
        </td></tr>
      HTML
    end

    # Add a label field (display-only) to the form.
    # The field will render as a grey box.
    # An optional accompanying hidden input can be rendered:
    #    with name = FORM_NAME[FIELD_NAME]
    #    and id = FORM_NAME_FIELD_NAME.
    #
    # @param name [string] the name of the form field.
    # @param label [string] the caption for the label to appear beside the input.
    # @param value [string] the value to be displayed in the label.
    # @param hidden_value [string] the value of the hidden field. If nil, no hidden field will be generated.
    # @return [void]
    def add_label(name, label, value, hidden_value = nil)
      @fields << <<~HTML
        <tr><th align="left">#{label}</th>
        <td><div class="pa2 bg-moon-gray br2">#{value}</div>#{hidden_label(name, hidden_value)}
        </td></tr>
      HTML
    end

    # Render the form.
    #
    # @return [String] HTML for the form.
    def render
      raise ArgumentError, 'RMDForm: no CSRF tag provided' if csrf_tag.nil?

      <<~HTML
        <h2>#{caption}#{page_number_and_page_count}</h2>
        <form action="#{action}" method="POST">
          #{error_section}
          #{notes_section}
          #{camera_section}
          #{csrf_tag}
          #{field_renders}
          #{submit_section}
        </form>
        #{progress_section}
        <div id="txtShow" class="navy bg-light-blue mw6 pa2"></div>
      HTML
    end

    # Set the CSRF tag.
    #
    # @return [void]
    def add_csrf_tag(value)
      @csrf_tag = value
    end

    private

    def page_number_and_page_count
      return '' if @step_count.nil?

      %(<span class="mid-gray"> &ndash; (step #{@step_number} of #{@step_count})</span>)
    end

    def decimal_or_int(data_type, options)
      return '' unless data_type == 'number'
      return '' unless options[:allow_decimals]

      ' step="any"'
    end

    def lookup_data(options)
      return '' unless options[:lookup]

      ' data-lookup="Y"'
    end

    def lookup_display(name, options) # rubocop:disable Metrics/AbcSize
      return '' unless options[:lookup]

      <<~HTML
        <div id ="#{form_name}_#{name}_scan_lookup" class="b gray" data-lookup-result="Y" data-reset-value="#{form_state.fetch(:lookup_values, {})[name] || '&nbsp;'}">#{form_state.fetch(:lookup_values, {})[name] || '&nbsp;'}</div>
        <input id ="#{form_name}_#{name}_scan_lookup_hidden" type="hidden" data-lookup-hidden="Y" data-reset-value="#{form_state.fetch(:lookup_values, {})[name] || '&nbsp;'}" name="lookup_values[#{name}]" value="#{form_state.fetch(:lookup_values, {})[name]}">
      HTML
    end

    def hidden_label(name, hidden_value)
      value = hidden_value || form_state[name]
      return '' if value.nil?

      <<~HTML
        <input id ="#{form_name}_#{name}" type="hidden" name="#{form_name}[#{name}]" value="#{value}">
      HTML
    end

    def submit_form(options)
      return '' unless options[:submit_form]

      ' data-submit-form="Y"'
    end

    # Set autofocus on fields in error, or else on the first field.
    def autofocus_for_field(name)
      if @form_state[:errors]
        if @form_state[:errors].key?(name)
          ' autofocus'
        else
          ''
        end
      else
        @fields.empty? ? ' autofocus' : ''
      end
    end

    def hidden_scan_type(name, options)
      return '' unless options[:scan]

      <<~HTML
        <input id="#{form_name}_#{name}_scan_field" type="hidden" name="#{form_name}[#{name}_scan_field]" value="#{form_state["#{name}_scan_field".to_sym]}">
      HTML
    end

    def field_renders
      <<~HTML
        <table><tbody>
          #{@fields.join("\n")}
        </tbody></table>
      HTML
    end

    def scan_opts(options)
      if options[:scan]
        %( data-scanner="#{options[:scan]}" data-scan-rule="#{options[:scan_type]}" autocomplete="off")
      else
        ''
      end
    end

    def field_error_state
      val = form_state[:errors] && form_state[:errors][@current_field]
      return '' unless val

      ' class="bg-washed-red"'
    end

    def field_error_message
      val = form_state[:errors] && form_state[:errors][@current_field]
      return '' unless val

      "<span class='brown'><br>#{val.compact.join('; ')}</span>"
    end

    def field_error_class
      val = form_state[:errors] && form_state[:errors][@current_field]
      return '' unless val

      ' bg-washed-red'
    end

    def error_section
      show_hide = form_state[:error_message] ? '' : ' style="display:none"'
      <<~HTML
        <div id="rmd-error" class="brown bg-washed-red ba b--light-red pa3 mw6"#{show_hide}>
          #{form_state[:error_message]}
        </div>
      HTML
    end

    def progress_section
      show_hide = progress ? '' : ' style="display:none"'
      <<~HTML
        <div id="rmd-progress" class="white bg-blue ba b--navy mt1 pa3 mw6"#{show_hide}>
          #{progress}
        </div>
      HTML
    end

    def notes_section
      return '' unless notes

      "<p>#{notes}</p>"
    end

    def submit_section
      <<~HTML
        <p>
          <input type="submit" value="#{button_caption}" data-disable-with="Submitting..." class="dim br2 pa3 bn white bg-green mr3" data-rmd-btn="Y"> #{links_section} #{reset_section}
        </p>
      HTML
    end

    def reset_section
      return '' unless @reset_button

      <<~HTML
        <input type="reset" class="dim br2 pa3 bn white bg-silver ml4" data-reset-rmd-form="Y">
      HTML
    end

    def links_section
      @links.map do |link|
        caption = link[:caption]
        url = link[:url]
        if link[:prompt]
          <<~HTML
            <a href="#{url}" class="dim link br2 pa3 bn white bg-dark-blue ml4" data-prompt="#{link[:prompt]}">#{caption}</a>
          HTML
        else
          <<~HTML
            <a href="#{url}" class="dim link br2 pa3 bn white bg-dark-blue ml4">#{caption}</a>
          HTML
        end
      end.join
    end

    def camera_section
      return '' unless scan_with_camera

      <<~HTML
        <button id="cameraScan" type="button" class="dim br2 pa3 bn white bg-blue">
          #{Crossbeams::Layout::Icon.render(:camera)} Scan with camera
        </button>
      HTML
    end

    def make_prompt(prompt)
      return '' if prompt.nil?

      str = prompt.is_a?(String) ? prompt : 'Select a value'
      "<option value=\"\">#{str}</option>\n"
    end

    def build_options(list, selected)
      if list.is_a?(Hash)
        opts = []
        list.each do |group, sublist|
          opts << %(<optgroup label="#{group}">)
          opts << make_options(Array(sublist), selected)
          opts << '</optgroup>'
        end
        opts.join("\n")
      else
        make_options(Array(list), selected)
      end
    end

    def make_options(list, selected)
      opts = list.map do |a|
        a.is_a?(Array) ? option_string(a.first, a.last, selected) : option_string(a, a, selected)
      end
      opts.join("\n")
    end

    def option_string(text, value, selected)
      sel = selected && value.to_s == selected.to_s ? ' selected ' : ''
      "<option value=\"#{CGI.escapeHTML(value.to_s)}\"#{sel}>#{CGI.escapeHTML(text.to_s)}</option>"
    end
  end
end
