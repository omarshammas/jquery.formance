assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')

describe 'time_yy_mm.js', ->

    describe 'format_time_yy_mm', ->

        it 'should format time in years and months correctly', ->
            $number = $('<input type=text>').formance('format_time_yy_mm')
            $number.val('0')

            e = $.Event('keypress')
            e.which = 52 # '4'
            $number.trigger(e)

            assert.equal '04 / ', $number.val()

    describe 'validating time with validate_time_yy_mm', ->
        
        it 'should fail if empty', ->
            $num = $('<input type=text>').val('')
            assert.equal false, $num.formance('validate_time_yy_mm')

        it 'should fail if is a bunch of spaces', ->
            $num = $('<input type=text>').val('                        ')
            assert.equal false, $num.formance('validate_time_yy_mm')

        it 'should success if is valid', ->
            $num = $('<input type=text>').val('11 / 04')
            assert.equal true, $num.formance('validate_time_yy_mm')

        it 'should success if is less than 4 digits', ->
            $num = $('<input type=text>').val('00 / 1')
            assert.equal true, $num.formance('validate_time_yy_mm')

        it 'should success if is less than 4 digits', ->
            $num = $('<input type=text>').val('0 / 10')
            assert.equal true, $num.formance('validate_time_yy_mm')

        it 'should success if is less than 4 digits', ->
            $num = $('<input type=text>').val('0 / 1')
            assert.equal true, $num.formance('validate_time_yy_mm')            

        it 'should fail if no slash inputted and greater than 2 digits', ->
            $num = $('<input type=text>').val('0010')
            assert.equal false, $num.formance('validate_time_yy_mm')

        it 'should success if no years and months greater than 12', ->
            $num = $('<input type=text>').val('00/24')
            assert.equal true, $num.formance('validate_time_yy_mm')

        it 'should success if slash present but no spaces', ->
            $num = $('<input type=text>').val('00/10')
            assert.equal true, $num.formance('validate_time_yy_mm')

        it 'should fail if string contains non digits', ->
            $num = $('<input type=text>').val('00 / 0w')
            assert.equal false, $num.formance('validate_time_yy_mm')