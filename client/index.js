const express = require('express')
const app = express()

app.get('/', (req, res) => {
  const hostname = req.hostname;
  const subdomain = hostname.split('.')[0];
  res.send(`You asked for ${subdomain}`);
})

app.listen(8000, () => {
  console.log('Example app listening on port 8000!')
});
