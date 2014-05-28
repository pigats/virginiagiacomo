var id = require('system').args[1];
var page = require('webpage').create();


page.paperSize = {
  format: 'A4',
  orientation: 'portrait',
  border: '1cm'
}

page.open('http://localhost:3000/honeymoon/contributions/' + id + '/receipt', function() {
  page.render('pdfs/' + id + '.pdf');
  phantom.exit();
});