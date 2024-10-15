var background = {
  "port": null,
  "message": {},
  "receive": function (id, callback) {
    if (id) {
      background.message[id] = callback;
    }
  },
  "send": function (id, data) {
    if (id) {
      chrome.runtime.sendMessage({
        "method": id,
        "data": data,
        "path": "popup-to-background"
      }, function () {
        return chrome.runtime.lastError;
      });
    }
  },
  "connect": function (port) {
    chrome.runtime.onMessage.addListener(background.listener); 
    /*  */
    if (port) {
      background.port = port;
      background.port.onMessage.addListener(background.listener);
      background.port.onDisconnect.addListener(function () {
        background.port = null;
      });
    }
  },
  "post": function (id, data) {
    if (id) {
      if (background.port) {
        background.port.postMessage({
          "method": id,
          "data": data,
          "path": "popup-to-background",
          "port": background.port.name
        });
      }
    }
  },
  "listener": function (e) {
    if (e) {
      for (let id in background.message) {
        if (background.message[id]) {
          if ((typeof background.message[id]) === "function") {
            if (e.path === "background-to-popup") {
              if (e.method === id) {
                background.message[id](e.data);
              }
            }
          }
        }
      }
    }
  }
};

var config = {
  "options": {},
  "timeout": null,
  "update": function (name) {
    const element = document.getElementById(name);
    /*  */
    if (element.type === "range") {
      const title = document.getElementById(name + ".value");
      /*  */
      if (title) {
        const n = Number(element.value);
        /*  */
        if (name === "amplify") title.textContent = Math.floor(n * 100) + '%';
        else if (name === "volume") title.textContent = Math.floor(n * 100);
        else if (name === "positionX") title.textContent = n;
        else if (name === "positionY") title.textContent = n;
        else if (name === "positionZ") title.textContent = n;
        else title.textContent = Math.floor(n * 100) + '%';
      }
    }
  },
  "attribute": function () {
    document.documentElement.removeAttribute("permission");
    /*  */
    chrome.tabs.query({"active": true, "currentWindow": true}, function (tabs) {
      if (tabs && tabs.length) {
        if (tabs[0]) {
          if (tabs[0].url) {
            try {
              const url = new URL(tabs[0].url);
              chrome.permissions.contains({
                "origins": [url.origin + "/*"]
              }, function (permission) {
                if (permission === true) {
                  document.documentElement.setAttribute("permission", '');
                }
              });
            } catch (e) {}
          }
        }
      }
    });
  },
  "render": function (e) {
    if (e) {
      config.options = e;
      /*  */
      for (let name in config.options) {
        const element = document.getElementById(name);
        if (element) {
          if (element.type === "radio") {
            element.checked = config.options[name];
          } else {
            element.value = config.options[name];
          }
          /*  */
          config.update(name);
        }
      }
      /*  */
      config.attribute();
    }
  },
  "inject": function () {
    if (config.timeout) window.clearTimeout(config.timeout);
    config.timeout = window.setTimeout(function () {
      chrome.tabs.query({"active": true, "currentWindow": true}, function (tabs) {
        if (tabs && tabs.length) {
          if (tabs[0]) {
            if (tabs[0].url) {
              if (tabs[0].url.indexOf("http") === 0) {
                config.attribute();
                /*  */
                if (chrome.scripting) {
                  chrome.scripting.executeScript({
                    "world": "MAIN",
                    "args": [config.options],
                    "func": function (e) {
                      window._SoundAdjustmentMetrics = e;
                    },
                    "target": {
                      "allFrames": true,
                      "tabId": tabs[0].id
                    }
                  }, function () {
                    chrome.scripting.executeScript({
                      "world": "MAIN",
                      "files": ["/data/content_script/inject.js"],
                      "target": {
                        "allFrames": true,
                        "tabId": tabs[0].id
                      }
                    }, function () {
                      background.send("store", {
                        "tabId": tabs[0].id,
                        "options": config.options
                      });
                      /*  */
                      try {
                        const url = new URL(tabs[0].url);
                        const permission = document.documentElement.getAttribute("permission");
                        if (permission !== null) {
                          background.send("store", {
                            "origin": url.origin,
                            "options": config.options
                          });
                        }
                      } catch (e) {}
                    });
                  });
                }
              }
            }
          }
        }
      });
    }, 100);
  },
  "load": function () {
    const volume = document.getElementById("volume");
    const reload = document.getElementById("reload");
    const panner = document.getElementById("panner");
    const amplify = document.getElementById("amplify");
    const balance = document.getElementById("balance");
    const support = document.getElementById("support");
    const listener = document.getElementById("listener");
    const donation = document.getElementById("donation");
    const positionX = document.getElementById("positionX");
    const positionY = document.getElementById("positionY");
    const positionZ = document.getElementById("positionZ");
    const persistent = document.getElementById("persistent");
    /*  */
    volume.addEventListener("input", config.listener.input);
    amplify.addEventListener("input", config.listener.input);
    balance.addEventListener("input", config.listener.input);
    panner.addEventListener("change", config.listener.change);
    positionX.addEventListener("input", config.listener.input);
    positionY.addEventListener("input", config.listener.input);
    positionZ.addEventListener("input", config.listener.input);
    listener.addEventListener("change", config.listener.change);
    persistent.addEventListener("click", config.listener.permission);
    /*  */
    reload.addEventListener("click", function () {background.send("reload")});
    support.addEventListener("click", function () {background.send("support")});
    donation.addEventListener("click", function () {background.send("donation")});
    /*  */
    chrome.tabs.query({"active": true, "currentWindow": true}, function (tabs) {
      if (tabs && tabs.length) {
        background.send("load", {
          "url": tabs[0].url,
          "tabId": tabs[0].id
        });
      }
    });
    /*  */
    window.removeEventListener("load", config.load, false);
  },
  "listener": {
    "input": function (e) {
      const name = e.target.id;
      const value = e.target.value;
      /*  */
      config.options[name] = Number(value);
      config.update(name);
      config.inject();
    },
    "change": function (e) {
      const name = e.target.id;
      const checked = e.target.checked;
      const other = name === "panner" ? "listener" : "panner";
      /*  */
      config.options[name] = checked;
      config.options[other] = !checked;
      document.getElementById(other).checked = !checked;
      config.inject();
    },
    "permission": function () {
      chrome.tabs.query({"active": true, "currentWindow": true}, function (tabs) {
        if (tabs && tabs.length) {
          if (tabs[0]) {
            if (tabs[0].url) {
              try {
                const url = new URL(tabs[0].url);
                chrome.permissions.contains({
                  "origins": [url.origin + "/*"]
                }, function (permission) {
                  if (permission === true) {
                    chrome.permissions.remove({
                      "origins": [url.origin + "/*"]
                    }, function () {
                      config.attribute();
                    });
                  } else {
                    chrome.permissions.request({
                      "origins": [url.origin + "/*"]
                    }, function () {
                      config.attribute();
                    });
                  }
                });
              } catch (e) {}
            }
          }
        }
      });
    }
  }
};

background.receive("storage", config.render);
background.connect(chrome.runtime.connect({"name": "popup"}));

window.addEventListener("load", config.load, false);
