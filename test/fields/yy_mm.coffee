assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')

describe 'yy_mm.js', ->

    describe 'format_yy_mm', ->

        it 'should format time in years and months correctly', ->
            $number = $('<input type=text>').formance('format_yy_mm')
            $number.val('0')

            e = $.Event('keypress')
            e.which = 52 # '4'
            $number.trigger(e)

            assert.equal '04 / ', $number.val()

    describe 'Validating time in years and months', ->

        it 'should fail if empty', ->
            $num = $('<input type=text>').val('')
            assert.equal false, $num.formance('validate_yy_mm')

        it 'should fail if is a bunch of spaces', ->
            $num = $('<input type=text>').val('                        ')
            assert.equal false, $num.formance('validate_yy_mm')

        it 'should success if is valid', ->
            $num = $('<input type=text>').val('11 / 04')
            assert.equal true, $num.formance('validate_yy_mm')

        it 'should fail if is less than 7 digits', ->
            $num = $('<input type=text>').val('00 / 1')
            assert.equal false, $num.formance('validate_yy_mm')
