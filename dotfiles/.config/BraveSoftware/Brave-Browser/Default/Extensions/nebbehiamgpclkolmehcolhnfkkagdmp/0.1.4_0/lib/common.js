var core = {
  "start": function () {
    core.load();
  },
  "install": function () {
    core.load();
  },
  "load": function () {
    config.addon.data = {};
    config.addon.origin = {};
  },
  "query": {
    "args": function (tab) {
      if (tab) {
        if (tab.url) {
          try {
            const url = new URL(tab.url);
            const data = config.addon.data;
            const origin = config.addon.origin;
            /*  */
            if (data[tab.id]) {
              return data[tab.id];
            } else {
              if (origin[url.origin]) {
                return origin[url.origin];
              }
            }
          } catch (e) {}
        }
      }
      /*  */
      return null;
    }
  },
  "action": {
    "storage": function (changes, namespace) {
      /*  */
    },
    "tab": function (tab) {
      if (tab) {
        if (tab.url) {
          try {
            const url = new URL(tab.url);
            chrome.permissions.contains({
              "origins": [url.origin + "/*"]
            }, function (result) {
              if (result === true) {
                core.action.inject(tab);
              }
            });
          } catch (e) {}
        }
      }
    },
    "inject": function (tab) {
      if (tab) {
        if (tab.url) {
          const args = core.query.args(tab);
          if (args) {
            if (chrome.scripting) {
              chrome.scripting.executeScript({
                "args": [args],
                "world": "MAIN",
                "func": function (e) {
                  window._SoundAdjustmentMetrics = e;
                },
                "target": {
                  "tabId": tab.id,
                  "allFrames": true
                }
              }, function () {
                chrome.scripting.executeScript({
                  "world": "MAIN",
                  "files": ["/data/content_script/inject.js"],
                  "target": {
                    "tabId": tab.id,
                    "allFrames": true
                  }
                }, function () {});
              });
            }
          }
        }
      }
    },
    "popup": {
      "reload": function () {
        app.tab.query.active(function (tab) {
          if (tab) {
            app.tab.reload(tab.id);
          }
        });
      },
      "store": function (e) {
        if (e) {
          const data = config.addon.data;
          const origin = config.addon.origin;
          /*  */
          if ("tabId" in e) {
            data[e.tabId] = e.options;
            config.addon.data = data;
          }
          /*  */
          if ("origin" in e) {
            if (e) {
              origin[e.origin] = e.options;
              config.addon.origin = origin;
            }
          }
        }
      },
      "load": function (e) {
        if (e) {
          try {
            const url = new URL(e.url);
            const data = config.addon.data;
            const origin = config.addon.origin;
            /*  */
            const metrics = {
              "balance": 0,
              "amplify": 1,
              "volume": 0.1,
              "positionX": 0,
              "positionY": 0,
              "positionZ": 0,
              "panner": false,
              "listener": true
            };
            /*  */
            const storage = data[e.tabId] || origin[url.origin] || metrics;
            app.popup.send("storage", storage);
          } catch (e) {}
        }
      }
    }
  }
};

app.tab.on.created(core.action.tab);
app.tab.on.updated(core.action.tab);

app.popup.receive("load", core.action.popup.load);
app.popup.receive("store", core.action.popup.store);
app.popup.receive("reload", core.action.popup.reload);
app.popup.receive("support", function () {app.tab.open(app.homepage())});
app.popup.receive("donation", function () {app.tab.open(app.homepage() + "?reason=support")});

app.on.startup(core.start);
app.on.installed(core.install);
app.on.storage(core.action.storage);
