const http = require('https')
const querystring = require('querystring')
const config = require('./config')

const options = {
  ...config.slack,
  method: 'POST',
  port: '443',
}

const notifySlack = message => {
  console.log('message:', message)
  const slack_block = JSON.stringify({
    blocks: [
      {
        type: 'context',
        elements: [
          {
            type: 'mrkdwn',
            text: message,
          }
        ],
      }
    ],
  })

  options.headers = {
    'Content-Type': 'application/json',
  }

  console.log(options)
  console.log(slack_block)
  const slack_req = http.request(options, res => {
    res.setEncoding('utf8')
    res.on('data', chunk => {
      console.log(chunk)
    })
  })

  slack_req.write(slack_block)
  slack_req.end()
}

module.exports = {
  notifySlack
}
