require('./app/styles.scss')
var Elm = require('./app/Main.elm')

Elm.Main.embed(document.getElementById('main'))
