###
THE PATTERN MODULE
http://toddmotto.com/mastering-the-module-pattern/
###
'use strict'

Module = (->
  privateMethod = ->

  # private
  someMethod = ->

  # public
  anotherMethod = ->

  # public
  someMethod: someMethod
  anotherMethod: anotherMethod

)()


# Extender o Módulo Inicial com mais funcionalidade
ModuleTwo = ((Module) ->

  Module.extension = ->
    console.log "Module is Extended"

  return Module

# access to `Module`
)(Module or {})

console.log Module