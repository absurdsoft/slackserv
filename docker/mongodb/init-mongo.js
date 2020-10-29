db.auth('root', 'password')

db = db.getSiblingDB('slackserv')

db.createUser({
  user: 'user',
  pwd: 'password',
  roles: [{
    role: 'dbAdmin',
    db: 'slackserv'
  }, {
    role: 'readWrite',
    db: 'slackserv'
  }]
})

