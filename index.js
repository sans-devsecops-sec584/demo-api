var ip = require('ip');
var restify = require('restify');

const server = restify.createServer({
  name: 'demo-api',
  version: '0.0.1'
});

var port = process.env.DEMO_API_PORT || '9000'
var message = process.env.MESSAGE || 'Hello, world';
var pkg = require('./package.json');

server.use(restify.plugins.acceptParser(server.acceptable));
server.use(restify.plugins.queryParser());
server.use(restify.plugins.bodyParser());
 
server.get('/', function (req, res, next) {
  res.send(200, `${message} | ${ip.address()} | Version ${pkg.version}`);
  return next();
});
 
server.listen(port, function () {
  console.log('%s listening at %s', server.name, server.url);
});