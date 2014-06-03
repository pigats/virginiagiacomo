var system = require('system');
var url = system.args[1];
var path = system.args[2];
var locale = system.args[3];
var page = require('webpage').create();

page.customHeaders = {
  'HTTP_ACCEPT_LANGUAGE': locale // this does not work on the webfonts enabled custom build
};

page.paperSize = {
  format: 'A4',
  orientation: 'portrait',
  border: '1cm'
};

page.open(url, function() {
  page.render(path);
  phantom.exit();
});