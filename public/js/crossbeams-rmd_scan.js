const crossbeamsRmdScan = (function crossbeamsRmdScan() { // eslint-disable-line no-unused-vars
  //
  // Variables
  //
  const publicAPIs = { bypassRules: false };

  const txtShow = document.getElementById('txtShow');
  const menu = document.getElementById('rmd_menu');
  const logout = document.getElementById('logout');
  const offlineStatus = document.getElementById('rmd-offline-status');
  const scannableInputs = document.querySelectorAll('[data-scanner]');
  const cameraScan = document.getElementById('cameraScan');
  let webSocket;

  //
  // Methods
  //

  /**
   * Update the UI when the network connection is lost/regained.
   */
  const updateOnlineStatus = () => {
    if (navigator.onLine) {
      offlineStatus.style.display = 'none';
      if (menu) {
        menu.disabled = false;
      }
      logout.classList.remove('disableClick');
      document.querySelectorAll('[data-rmd-btn]').forEach((node) => {
        node.disabled = false;
      });
      publicAPIs.logit('Online: network connection restored');
    } else {
      offlineStatus.style.display = '';
      if (menu) {
        menu.disabled = true;
      }
      logout.classList.add('disableClick');
      document.querySelectorAll('[data-rmd-btn]').forEach((node) => {
        node.disabled = true;
      });
      publicAPIs.logit('Offline: network connection lost');
    }
  };

  /**
   * Disable a button and change its caption.
   * @param {element} button the button to disable.
   * @param {string} disabledText the text to use to replace the caption.
   * @returns {void}
   */
  const disableButton = (button, disabledText) => {
    button.dataset.enableWith = button.value;
    button.value = disabledText;
    button.classList.remove('dim');
    button.classList.add('o-50');
  };

  /**
   * Remove disabled state from a button.
   * @param {element} element the button to re-enable.
   * @returns {void}
   */
  const revertDisabledButton = (element) => {
    element.disabled = false;
    element.value = element.dataset.enableWith;
    element.classList.add('dim');
    element.classList.remove('o-50');
  };

  /**
   * Get a lookup value to display on the form
   * next to the field that was scanned.
   * @param {element} the element that has just
   * neen scanned.
   * @returns {void}
   */
  const lookupScanField = (element, scanPack) => {
    const url = `/rmd/utilities/lookup/${scanPack.scanType}/${scanPack.scanField}/${element.value}`;
    const label = document.getElementById(`${element.id}_scan_lookup`);
    const hiddenVal = document.getElementById(`${element.id}_scan_lookup_hidden`);
    console.log('lbl', label);
    if (label === null) return null;

    fetch(url, {
      method: 'GET',
      headers: new Headers({
        'X-Custom-Request-Type': 'Fetch',
      }),
      credentials: 'same-origin',
    }).then((response) => {
      if (response.status === 404) {
        label.innerHTML = '<span class="light-red">404</span>';
        console.log('404', url); // eslint-disable-line no-console
        return {};
      }
      return response.json();
    }).then((data) => {
      if (data.flash) {
        if (data.flash.type && data.flash.type === 'permission') {
          label.innerHTML = '<span class="light-red">Permission error</span>';
        } else {
          label.innerHTML = '<span class="light-red">Error</span>';
        }
        if (data.exception) {
          if (data.backtrace) {
            console.groupCollapsed('EXCEPTION:', data.exception, data.flash.error); // eslint-disable-line no-console
            console.info('==Backend Backtrace=='); // eslint-disable-line no-console
            console.info(data.backtrace.join('\n')); // eslint-disable-line no-console
            console.groupEnd(); // eslint-disable-line no-console
          }
        }
      } else {
        label.innerHTML = data.showField;
        hiddenVal.value = data.showField;
      }
    }).catch((data) => {
      console.info('==ERROR==', data); // eslint-disable-line no-console
    });
    return null;
  };

  /**
   * When an input is invalid according to HTML5 rules and
   * the submit button has been disabled, we need to re-enable it
   * so the user can re-submit the form once the error has been
   * corrected.
   */
  document.addEventListener('invalid', (e) => {
    window.setTimeout(() => {
      const sel = '[data-disable-with][disabled], [data-briefly-disable-with][disabled]';
      e.target.form.querySelectorAll(sel).forEach(el => revertDisabledButton(el));
    }, 0); // Disable the button with a delay so the form still submits...
  }, true);

  /**
   * Prevent multiple clicks of submit buttons.
   * @returns {void}
   */
  const preventMultipleSubmits = (element) => {
    disableButton(element, element.dataset.disableWith);
    window.setTimeout(() => {
      element.disabled = true;
    }, 0); // Disable the button with a delay so the form still submits...
  };

  /**
   * Event listeners for the RMD page.
   */
  const setupListeners = () => {
    window.addEventListener('online', updateOnlineStatus);
    window.addEventListener('offline', updateOnlineStatus);
    if (menu) {
      menu.addEventListener('change', (event) => {
        if (event.target.value !== '') {
          window.location = event.target.value;
        }
      });
    }
    document.body.addEventListener('click', (event) => {
      // On a touch device, try to prevent the form from
      // being submitted after a scan...
      if (event.sourceCapabilities === null) {
        if (event.target.dataset && event.target.dataset.rmdBtn) {
          event.preventDefault();
          return;
        }
      }
      // Disable a button on click
      if (event.target.dataset && event.target.dataset.disableWith) {
        preventMultipleSubmits(event.target);
      }
      // On reset button clicked, clear all lookup results
      if (event.target.dataset && event.target.dataset.resetRmdForm) {
        event.target.form.querySelectorAll('[data-lookup-result]').forEach((node) => {
          node.innerHTML = node.dataset.resetValue;
        });
        event.target.form.querySelectorAll('[data-lookup-hidden]').forEach((node) => {
          node.value = node.dataset.resetValue === '&nbsp;' ? '' : node.dataset.resetValue;
        });
      }
      // On link click, if there is a propmt, display it for the user to confirm.
      if (event.target.dataset && event.target.dataset.prompt) {
        event.stopPropagation();
        event.preventDefault();
        swal({
          title: '',
          text: event.target.dataset.prompt,
          type: 'warning',
          showCancelButton: true }).then(() => {
            window.location = event.target.href;
          }, null).catch(swal.noop);
      }
    });

    if (cameraScan) {
      cameraScan.addEventListener('click', () => {
        webSocket.send('Type=key248_all');
      });
    }
  };

  /**
   * Apply scan rules to the scanned value
   * to dig out the actual value and type.
   *
   * @param {string} val - the scanned value.
   * @returns {object} success: boolean, value: the value, scanType: the type, error: string.
   */
  const unpackScanValue = (val) => {
    const res = { success: false };
    // If we can scan any barcode, return whatever was scanned:
    if (publicAPIs.bypassRules) {
      res.success = true;
      res.value = val;
      res.scanType = 'any';
      res.scanField = 'any';
      return res;
    }
    const matches = [];
    let rxp;
    this.rules.filter(r => this.expectedScanTypes.indexOf(r.type) !== -1).forEach((rule) => {
      rxp = RegExp(rule.regex);
      if (rxp.test(val)) {
        matches.push(rule.type);
        res.value = RegExp.lastParen;
        res.scanType = rule.type;
        res.scanField = rule.field;
      }
    });
    if (matches.length !== 1) {
      res.error = matches.length === 0 ? `${val} does not match any scannable rules` : 'Too many rules match';
    } else {
      res.success = true;
    }
    return res;
  };

  /**
   * startScanner - set up the websocket connection and its callbacks.
   */
  const startScanner = () => {
    const wsUrl = 'ws://127.0.0.1:2115';
    let connectedState = false;

    if (webSocket !== undefined && webSocket.readyState !== WebSocket.CLOSED) { return; }
    webSocket = new WebSocket(wsUrl);

    webSocket.onopen = function onopen() {
      connectedState = true;
      publicAPIs.logit('Connected...');
    };

    webSocket.onclose = function onclose() {
      connectedState = false;
      publicAPIs.logit('Connection Closed...');
      // delay for a second and try again...
      setTimeout(startScanner, 1000);
    };

    webSocket.onerror = function onerror(event) {
      if (connectedState) { // Ignore websocket errors if we are not connected.
        publicAPIs.logit('Connection ERROR', event);
      }
    };

    webSocket.onmessage = function onmessage(event) {
      if (event.data.includes('[SCAN]')) {
        const scanPack = unpackScanValue(event.data.split(',')[0].replace('[SCAN]', ''));
        if (!scanPack.success) {
          publicAPIs.logit(scanPack.error);
          return;
        }
        let cnt = 0;
        scannableInputs.forEach((e) => {
          if (e.value === '' && cnt === 0 && (publicAPIs.bypassRules || e.dataset.scanRule === scanPack.scanType)) {
            e.value = scanPack.value;
            const field = document.getElementById(`${e.id}_scan_field`);
            if (field) {
              field.value = scanPack.scanField;
            }
            if (e.dataset.lookup) {
              lookupScanField(e, scanPack);
            }
            cnt += 1;
            if (e.dataset.submitForm) {
              e.form.submit();
            }
          }
        });
      }
      console.info('Raw msg:', event.data); // eslint-disable-line no-console
    };
  };

  //
  // PUBLIC Methods
  //

  /**
   * Log to screen and console.
   *
   * @param {Array} args.
   */
  publicAPIs.logit = (...args) => {
    console.info(...args); // eslint-disable-line no-console
    if (txtShow !== null) {
      txtShow.insertAdjacentHTML('beforeend', `${Array.from(args).map(a => (typeof (a) === 'string' ? a : JSON.stringify(a))).join(' ')}<br>`);
    }
  };

  /**
   * show settings in use for this page.
   */
  publicAPIs.showSettings = () => ({
    expectedScanTypes: this.expectedScanTypes,
    rules: this.rules,
    rulesForThisPage: this.rules.filter(r => this.expectedScanTypes.indexOf(r.type) !== -1),
  });

  /**
   * Init
   * Find the possible scan types in the page.
   * Call setupListeners to set up listeners for the page.
   * Call startScanner to make the websocket connection.
   *
   * @param {object} rules - the rules for identifying scan values.
   * @param {boolean} bypassRules - should the rules be ignored (scan any barcode).
   */
  publicAPIs.init = (rules, bypassRules) => {
    this.rules = rules;
    publicAPIs.bypassRules = bypassRules;
    this.expectedScanTypes = Array.from(document.querySelectorAll('[data-scan-rule]')).map(a => a.dataset.scanRule);
    this.expectedScanTypes = this.expectedScanTypes.filter((it, i, ar) => ar.indexOf(it) === i);

    setupListeners();

    startScanner();
  };

  //
  // Return the Public APIs
  //
  return publicAPIs;
}());
