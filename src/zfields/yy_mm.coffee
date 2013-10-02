$ = jQuery
hasTextSelected = $.formance.fn.hasTextSelected

restrictTimeYYMM = (e) ->
	$target = $(e.currentTarget)
	digit = String.fromCharCode(e.which)
	return unless /^\d+$/.test(digit)

	return if hasTextSelected($target)

	value = $target.val() + digit
	value = value.replace(/\D/g, '')

	return false if value.length > 4

formatTimeYYMM = (e) ->
	#Only format if input is a number
	digit = String.fromCharCode(e.which)
	return unless /^\d+$/.test(digit)

	$target = $(e.currentTarget)
	old_val = $target.val()
	val = old_val + digit

	if /^\d{2}$/.test(val)
		e.preventDefault()
		$target.val("#{val} / ")
	else if /^\d{2}\s\/\s\d{1}$/.test(val) and digit not in ['0', '1']
		e.preventDefault()
		$target.val("#{old_val}0#{digit}")


formatForwardTimeYYMM = (e) ->   #handles when the user enters the second digit
	digit = String.fromCharCode(e.which)
	return unless /^\d+$/.test(digit)

	$target = $(e.currentTarget)
	val     = $target.val()

	# handles when entering the 2nd and 4th digits
	if /^\d{2}$/.test(val)
		$target.val("#{val} / ")

formatForwardSlashTimeYYMM = (e) ->    # handles when the user hits '/'
	slash = String.fromCharCode(e.which)
	return unless slash is '/'

	$target = $(e.currentTarget)
	val     = $target.val()

	parse_year = /^(\d)$/

	if parse_year.test(val) and val.length == 2 or val.length == 1
		$target.val("0#{val} / ")

formatBackTimeYYMM = (e) ->
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
	if /\d(\s|\/)+$/.test(value)
		e.preventDefault()
		$target.val(value.replace(/\d(\s|\/)*$/, ''))
	else if /\s\/\s?\d?$/.test(value)
		e.preventDefault()
		$target.val(value.replace(/\s\/\s?\d?$/, ''))

$.formance.fn.format_yy_mm = ->
	@formance "restrictNumeric"
	@on "keypress", restrictTimeYYMM
	@on "keypress", formatTimeYYMM
	@on "keypress", formatForwardTimeYYMM
	@on "keypress", formatForwardSlashTimeYYMM
	@on "keypress", formatBackTimeYYMM
	this


# ------------------------------
# Validating Time YY / MM
# ------------------------------

parseTimeYYMM = (date_string) ->
	[year, month] = if date_string? then date_string.replace(/\s/g, '').split('/', 2) else [NaN, NaN]
	month   = parseInt(month, 10)
	year    = parseInt(year, 10)
	return year: year, month: month

$.formance.fn.val_yy_mm = ->
	date = parseTimeYYMM @.val()

	return no if not date.year? or isNaN(date.year)
	return no if not date.month? or isNaN(date.month)
	return date

$.formance.fn.validate_yy_mm = ->
	date_dict = parseTimeYYMM @.val()
	date = @formance "val_yy_mm"
	yymm = $(this).val().replace(/\D/g, '')
	return false unless yymm.length == 4
	return false unless date.month is date_dict.month
	return false unless date.year is date_dict.year
	true
