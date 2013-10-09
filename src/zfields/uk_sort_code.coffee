$ = jQuery
hasTextSelected = $.formance.fn.hasTextSelected
restrictUkSortCode = (e) ->
	$target = $(e.currentTarget)
	digit = String.fromCharCode(e.which)
	return unless /^\d+$/.test(digit)

	return if hasTextSelected($target)

	value = $target.val() + digit
	value = value.replace(/\D/g, '')

	return false if value.length > 6

formatForwardUkSortCode = (e) ->   #handles when the user enters the second digit
	digit = String.fromCharCode(e.which)
	return unless /^\d+$/.test(digit)

	$target = $(e.currentTarget)
	val     = $target.val()

	# handles when entering the 2nd and 4th digits
	if /^\d{2}$/.test(val) or /^\d{2}\s\-\s\d{2}$/.test(val)
		$target.val("#{val} - ")

formatBackUkSortCode = (e) ->
	# If shift+backspace is pressed
	return if e.meta

	$target = $(e.currentTarget)
	value   = $target.val()

	# Return unless backspacing
	return unless e.which is 8

	# Return if focus isn't at the end of the text
	return if $target.prop('selectionStart')? and
		$target.prop('selectionStart') isnt value.length

	# Remove the trailing space
	if /\d(\s|-)+$/.test(value)
		e.preventDefault()
		$target.val(value.replace(/\d(\s|-)*$/, ''))
	else if /\s-\s?\d?$/.test(value)
		e.preventDefault()
		$target.val(value.replace(/\s-\s?\d?$/, ''))	

formatUkSortCode = (e) ->
	digit = String.fromCharCode(e.which)
	return  unless /^\d+$/.test(digit)
	$target = $(e.currentTarget)
	old_val = $target.val()
	val = old_val + digit
	if /^\d{2}$/.test(val)
		e.preventDefault()
		return $target.val("" + val + " - ")
	else if /^\d{2}\s\-\s\d{2}$/.test(val)
		e.preventDefault()
		return $target.val("" + val + " - ")

$.formance.fn.format_uk_sort_code = (e) ->
	@formance "restrictNumeric"
	@on "keypress", restrictUkSortCode
	@on "keypress", formatUkSortCode
	@on "keypress", formatForwardUkSortCode
	@on "keypress", formatBackUkSortCode
	this

$.formance.fn.validate_uk_sort_code = -> 
	sortCode = $(this).val()
	# return false if sortCode.trim() == ''
	return true if /^(\d{2})[\s-]*(\d{2})[\s-]*(\d{2})[\s]*$/.test(sortCode)
	false