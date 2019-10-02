const AWS = require('aws-sdk')
const http = require('http')
const config = require('./.env')
console.log('Configure AWS')
console.log(config.aws)
AWS.config.update(config.aws)
const apiVersion = '2010-03-31'
const options = {
  socketPath: '/var/run/docker.sock',
  path: 'http://localhost/containers/json',
}

const textSuccess = data => {
  console.log(`Message id is ${data.MessageId}`)
}

const textError = err => {
  console.error(err, err.stack)
}

const notify = info => {
  const params = {
    ...config.sms,
    Message: `${info.name.substr(1)} is ${info.state}`,
  }

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

const callback = res => {
  console.log(res.statusCode)

  res.setEncoding('utf8')
  res.on('data', data => {
    const containers = JSON.parse(data)
    containers.forEach(container => {
      const [name] = container.Names
      const { State: state, Status: status } = container

      if (state.toLowerCase() === 'running') {
        console.log(`${name} ${status}`)
      } else {
        console.log(`${name} ${state}`)
        notify({ name, state, status })
      }
    })
  })
  res.on('error', console.error)
}

const client_request = http.request(options, callback)
client_request.end()
