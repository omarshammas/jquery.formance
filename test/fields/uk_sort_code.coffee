assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../../lib/jquery.formance.js')

describe 'uk_sort_code.js', ->

    describe 'format_uk_sort_code', ->

        it 'should format uk sort code correctly, inserts the first - after 2 digits', ->
            $number = $('<input type=text>').formance('format_uk_sort_code')
            $number.val('0')

            e = $.Event('keypress')
            e.which = 52 # '4'
            $number.trigger(e)

            assert.equal '04 - ', $number.val()

        it 'should format uk sort code correctly, inserts the second - after 4 digits', ->
            $number = $('<input type=text>').formance('format_uk_sort_code')
            $number.val('12 - 3')

            e = $.Event('keypress')
            e.which = 52 # '4'
            $number.trigger(e)

            assert.equal '12 - 34 - ', $number.val()

        it 'should only allow numbers', ->
            $number = $('<input type=text>').formance('format_uk_sort_code')
            $number.val('12 - 3')

            e = $.Event('keypress')
            e.which = 100 # 'd'
            $number.trigger(e)

            assert.equal '12 - 3', $number.val()

    describe 'Validating a uk sort code', ->

        it 'should fail if empty', ->
            $num = $('<input type=text>').val('')
            assert.equal false, $num.formance('validate_uk_sort_code')

        it 'should fail if there are a bunch of spaces', ->
            $num = $('<input type=text>').val('                        ')
            assert.equal false, $num.formance('validate_uk_sort_code')

        it 'should succeed if it is valid', ->
            $num = $('<input type=text>').val('123456')
            assert.equal true, $num.formance('validate_uk_sort_code')

        it 'should succeed if it is valid with formatting', ->
            $num = $('<input type=text>').val('11 - 11 - 11')
            assert.equal true, $num.formance('validate_uk_sort_code')

        it 'should succeed if it is valid with strange formatting', ->
            $num = $('<input type=text>').val('11 -11- 11')
            assert.equal true, $num.formance('validate_uk_sort_code')

        it 'should fail if less than 6 digits', ->
            $num = $('<input type=text>').val('00 - 00 - 0')
            assert.equal false, $num.formance('validate_uk_sort_code')

        it 'should fail if more than 6 digits', ->
            $num = $('<input type=text>').val('00 - 00 - 001')
            assert.equal false, $num.formance('validate_uk_sort_code')

        it 'should fail with non digits', ->
            $num = $('<input type=text>').val('00 - 00 - 0i')
            assert.equal false, $num.formance('validate_uk_sort_code')
