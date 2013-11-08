// tests on device
user_pref("marionette.defaultPrefs.enabled", true);

// debug certified via using app-manager
user_pref("devtools.debugger.enable-content-actors", true);
user_pref("devtools.debugger.forbid-certified-apps", false);