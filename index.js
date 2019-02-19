const http = require('http');
const fs = require('fs');

const server = http.createServer((_, response) => {
  fs.readFile('./index.html', (err, html) => {
    if (err) {
      throw err;
    }
    
    response.writeHeader(200, { 'Content-Type': 'text/html' });
    response.write(html);
    response.write(`Server time: ${new Date(Date.now()).toLocaleString()}`)
    response.end();
  });
});

const port = process.env.PORT || 1337
server.listen(port)

// console.log('Server running at http://localhost:%d', port)

