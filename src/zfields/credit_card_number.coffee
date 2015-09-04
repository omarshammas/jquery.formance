$ = jQuery
hasTextSelected = $.formance.fn.hasTextSelected

# Utils

defaultFormat = /(\d{1,4})/g

cards = [
  {
      type: 'maestro'
      pattern: /^(5018|5020|5038|6304|6759|676[1-3])/
      format: defaultFormat
      length: [12..19]
      cvcLength: [3]
      luhn: true
  }
  {
      type: 'dinersclub'
      pattern: /^(36|38|30[0-5])/
      format: defaultFormat
      length: [14]
      cvcLength: [3]
      luhn: true
  }
  {
      type: 'laser'
      pattern: /^(6706|6771|6709)/
      format: defaultFormat
      length: [16..19]
      cvcLength: [3]
      luhn: true
  }
  {
      type: 'jcb'
      pattern: /^35/
      format: defaultFormat
      length: [16]
      cvcLength: [3]
      luhn: true
  }
  {
      type: 'unionpay'
      pattern: /^62/
      format: defaultFormat
      length: [16..19]
      cvcLength: [3]
      luhn: false
  }
  {
      type: 'discover'
      pattern: /^(6011|65|64[4-9]|622)/
      format: defaultFormat
      length: [16]
      cvcLength: [3]
      luhn: true
  }
  {
      type: 'mastercard'
      pattern: /^5[1-5]/
      format: defaultFormat
      length: [16]
      cvcLength: [3]
      luhn: true
  }
  {
      type: 'amex'
      pattern: /^3[47]/
      format: /(\d{1,4})(\d{1,6})?(\d{1,5})?/
      length: [15]
      cvcLength: [3..4]
      luhn: true
  }
  {
      type: 'visa'
      pattern: /^4/
      format: defaultFormat
      length: [13..16]
      cvcLength: [3]
      luhn: true
  }
]

cardFromNumber = (num) ->
    num = (num + '').replace(/\D/g, '')
    return card for card in cards when card.pattern.test(num)

cardFromType = (type) ->
    return card for card in cards when card.type is type

luhnCheck = (num) ->
    odd = true
    sum = 0

    digits = (num + '').split('').reverse()

    for digit in digits
        digit = parseInt(digit, 10)
        digit *= 2 if (odd = !odd)
        digit -= 9 if digit > 9
        sum += digit
  
    sum % 10 == 0

# Format Card Number

restrictCardNumber = (e) ->
    $target = $(e.currentTarget)
    digit   = String.fromCharCode(e.which)
    return unless /^\d+$/.test(digit)

    return if hasTextSelected($target)

    # Restrict number of digits
    value = ($target.val() + digit).replace(/\D/g, '')
    card  = cardFromNumber(value)

    if card
        value.length <= card.length[card.length.length - 1]
    else
        # All other cards are 16 digits long
        value.length <= 16

reFormatCardNumber = (e) ->
    setTimeout =>
        $target = $(e.currentTarget)
        value   = $target.val()
        value   = $.formance.formatCreditCardNumber(value)
        $target.val(value)

formatCardNumber = (e) ->
    # Only format if input is a number
    digit = String.fromCharCode(e.which)
    return unless /^\d+$/.test(digit)

    $target = $(e.currentTarget)
    value   = $target.val()
    card    = cardFromNumber(value + digit)
    length  = (value.replace(/\D/g, '') + digit).length

    upperLength = 16
    upperLength = card.length[card.length.length - 1] if card
    return if length >= upperLength

    # Return if focus isn't at the end of the text
    return if $target.prop('selectionStart')? and
        $target.prop('selectionStart') isnt value.length

    if card && card.type is 'amex'
        # Amex cards are formatted differently
        re = /^(\d{4}|\d{4}\s\d{6})$/
    else
        re = /(?:^|\s)(\d{4})$/

    # If '4242' + 4
    if re.test(value)
        e.preventDefault()
        $target.val(value + ' ' + digit)

    # If '424' + 2
    else if re.test(value + digit)
        e.preventDefault()
        $target.val(value + digit + ' ')

formatBackCardNumber = (e) ->
    $target = $(e.currentTarget)
    value   = $target.val()
 
    return if e.meta

    # Return unless backspacing
    return unless e.which is 8

    # Return if focus isn't at the end of the text
    return if $target.prop('selectionStart')? and
        $target.prop('selectionStart') isnt value.length

    # Remove the trailing space
    if /\d\s$/.test(value)
        e.preventDefault()
        $target.val(value.replace(/\d\s$/, ''))
    else if /\s\d?$/.test(value)
        e.preventDefault()
        $target.val(value.replace(/\s\d?$/, ''))



setCardType = (e) ->
    $target  = $(e.currentTarget)
    val      = $target.val()
    cardType = $.formance.creditCardType(val) or 'unknown'

    unless $target.hasClass(cardType)
        allTypes = (card.type for card in cards)

        $target.removeClass('unknown')
        $target.removeClass(allTypes.join(' '))

        $target.addClass(cardType)
        $target.toggleClass('identified', cardType isnt 'unknown')
        $target.trigger('payment.cardType', cardType)

$.formance.creditCardType = (num) ->
    return null unless num
    cardFromNumber(num)?.type or null

$.formance.formatCreditCardNumber = (num) ->
    card = cardFromNumber(num)
    return num unless card

    upperLength = card.length[card.length.length - 1]

    num = num.replace(/\D/g, '')
    num = num[0..upperLength]

    if card.format.global
        num.match(card.format)?.join(' ')
    else
        groups = card.format.exec(num)
        groups?.shift()
        groups?.join(' ')


$.formance.fn.format_credit_card_number = ->
    @.formance('restrictNumeric')
    @on('keypress', restrictCardNumber)
    @on('keypress', formatCardNumber)
    @on('keydown', formatBackCardNumber)
    @on('keyup', setCardType)
    @on('paste', reFormatCardNumber)
    this

$.formance.fn.validate_credit_card_number = ->
    num = $(this).val()
    num = (num + '').replace(/\s+|-/g, '')
    return false unless /^\d+$/.test(num)

    card = cardFromNumber(num)
    return false unless card

    num.length in card.length and
        (card.luhn is false or luhnCheck(num))
