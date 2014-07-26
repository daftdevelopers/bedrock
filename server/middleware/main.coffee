{config, file} = require 'bedrock-utils'
path = require 'path'
_ = require 'underscore'
express = require 'express'

ext = path.extname __filename
options =
  exclude: [path.basename(__filename, ext)]
  extension: ext

module.exports = (app) ->
  middleware = file.requireDirectory path.join(__dirname), options

  utilities = [
    middleware.assets app
    middleware.client app
    middleware.missing app
    middleware.error app
  ]

  useUtility = (utility) ->
    return unless utility

    if _.isArray utility
      useUtility util for util in utility
    else if utility.dir? and utility.method?
      app.use utility.dir, utility.method
    else
      app.use utility

  useUtility utilities
