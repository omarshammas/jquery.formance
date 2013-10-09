jQuery(function($){
    fields = ['credit_card_number',
              'credit_card_expiry',
              'credit_card_cvc',
              'dd_mm_yyyy',
              'yyyy_mm_dd',
              'email',
              'number',
              'phone_number',
              'postal_code',
              'time_yy_mm',
              'uk_sort_code',
              'ontario_drivers_license_number',
              'ontario_photo_health_card_number',
              'ontario_outdoors_card_number']

     $.each( fields, function (index, value) {
        $('input.'+value).formance('format_'+value)
                         .addClass('form-control')
                         .wrap('<div class=\'form-group\' />')
                         .parent()
                            .append('<label class=\'control-label\'>Try This Demo!</label>');

        $('input.'+value).on('keyup change blur', function (value) {
            return function (event) {
                $this = $(this);
                if ($this.formance('validate_'+value)) {
                    $this.parent()
                            .removeClass('has-success has-error')
                            .addClass('has-success')
                            .children(':last')
                                .text('Valid!');
                } else {
                    $this.parent()
                            .removeClass('has-success has-error')
                            .addClass('has-error')
                            .children(':last')
                                .text('Invalid');
                }
            }
        }(value));
     });
});
