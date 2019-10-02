const AWS = require('aws-sdk')
const https = require('https')
const config = require('./config')
const { notifySlack } = require('./notify-slack')
console.log('Configure AWS')
console.log(config.aws)
AWS.config.update(config.aws)
const apiVersion = '2010-03-31'

const textSuccess = data => {
  console.log(`Message id is ${data.MessageId}`)
}

const textError = err => {
  console.error(err, err.stack)
}

const sms_cooldown = 10 // minutes
let countdown = sms_cooldown - 1
const notify = (server, state) => {
  const Message = `${server} current state: ${state}`
  const params = {
    ...config.sms,
    Message,
  }

  notifySlack(Message)

  if (!countdown) {
    countdown = sms_cooldown
    console.log('reset countdown')
    return
  }

  if (sms_cooldown != countdown + 1) {
    console.log(`Skipping. Text already sent ${sms_cooldown - countdown} minutes ago`)
    return
  }

  countdown = countdown - 1 

  const setSMSTypePromise = new AWS.SNS({ apiVersion })
    .setSMSAttributes({
      attributes: {
        DefaultSMSType: 'Transactional',
        ...config.sns,
      },
    }).promise()

  setSMSTypePromise.then(setting => {
    console.log(setting)
    const text = new AWS.SNS({ apiVersion }).publish(params).promise()

    text.then(textSuccess).catch(textError)
  }).catch(textError)
}

let data = ''
const callback = server => res => {
  if (res.statusCode >= 500) {
    console.err(res.statusCode)
    notify(server, `down [${res.statusCode}]`)
  } else {
    console.log('All things clear')
  }
}

const sites = require('./sites.js')
const sitrep = () => {
  let client_request

  sites.forEach(site => {
    client_request = https
      .get(site[0], callback(site[1]))
      .on('error', err => {
        notify(site[1], 'fatal error')
      })
    client_request.end()
  })
}

setInterval(() => {
  console.log('Ping servers')
  sitrep()
}, 60 * 1000) // Every minute

sitrep()

const http = require('http')

console.log('creating server')

const server = http.createServer((req, res) => {
  console.log('test')
  res.end();
});
server.listen(6969)
