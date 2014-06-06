var system = require('system');
var url = system.args[1];
var path = system.args[2];
var locale = system.args[3];
var page = require('webpage').create();

page.customHeaders = {
  'HTTP_ACCEPT_LANGUAGE': locale // this does not work on the webfonts enabled custom build
};

page.viewportSize = {
  width: 800,
  height: 377
};

page.paperSize = {
  width: '210mm',
  height: '99mm',
};

page.open(url, function() {
  page.render(path);
  phantom.exit();
});