assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')

describe 'uk_sort_code.js', ->

    describe 'format_uk_sort_code', ->

        it 'should format uk sort code correctly', ->
            $number = $('<input type=text>').formance('format_uk_sort_code')
            $number.val('0')

            e = $.Event('keypress')
            e.which = 52 # '4'
            $number.trigger(e)

            assert.equal '04 - ', $number.val()

    describe 'Validating a uk sort code', ->

        it 'should fail if empty', ->
            $num = $('<input type=text>').val('')
            assert.equal false, $num.formance('validate_uk_sort_code')

        it 'should fail if is a bunch of spaces', ->
            $num = $('<input type=text>').val('                        ')
            assert.equal false, $num.formance('validate_uk_sort_code')

        it 'should success if is valid', ->
            $num = $('<input type=text>').val('11 - 11 - 11')
            assert.equal true, $num.formance('validate_uk_sort_code')

        it 'should fail if is less than 12 digits', ->
            $num = $('<input type=text>').val('00 - 00 - 0')
            assert.equal false, $num.formance('validate_uk_sort_code')
