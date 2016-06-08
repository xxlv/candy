# node.js deps
fs   = require 'fs'

# app deps
yaml = require 'js-yaml'

config = fs.readFileSync './scripts/config.yaml' , 'utf8'

module.exports = yaml.load config

