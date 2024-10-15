var config = {};

config.welcome = {
  set lastupdate (val) {app.storage.write("lastupdate", val)},
  get lastupdate () {return app.storage.read("lastupdate") !== undefined ? app.storage.read("lastupdate") : 0}
};

config.addon = {
  set data (val) {app.storage.write("data", val)},
  set origin (val) {app.storage.write("origin", val)},
  get data () {return app.storage.read("data") !== undefined ? app.storage.read("data") : {}},
  get origin () {return app.storage.read("origin") !== undefined ? app.storage.read("origin") : {}}
};
