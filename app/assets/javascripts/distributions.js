 $(function () {
  var optionValues = [];
  (function () {
    $("#media_type_select option").each(function() {
      var value = $(this).text();
      if (value === "otro") { return };
      optionValues.push(value);
    });
  })();

  var initMediaType;
  (updateMediaType = function () {
    var format = $("#distribution_format");
    var mediaType = $("#distribution_media_type")

    if ($.inArray(format.val(), optionValues) !== -1) {
      $('#distribution_format').parent().hide();
      $("#media_type_select option")
        .filter(function(){  return $(this).html() == format })
        .attr('selected', true)
      $('#distribution_format').val(format.val());
      $('#distribution_media_type').val(mediaType.val());
    } else {
      $('#distribution_format').parent().show();
      $('#media_type_select option')
        .filter(function () { return $(this).html() == "otro"; })
        .attr("selected", true);
    }
  })();

  var updateMediaType;
  updateMediaType = function () {
    var select = $('#media_type_select option:selected');
    var mediaType = select.val();
    var format = select.text();

    if ($.inArray(format, optionValues) !== -1) {
      $('#distribution_format').parent().hide();
      $('#distribution_format').val(format);
      $('#distribution_media_type').val(mediaType);
    } else {
      $('#distribution_format').parent().show();
      $('#distribution_format').val('');
      $('#distribution_media_type').val('');
    }
  }

  var showProprietaryFormatAlert;
  (
    showProprietaryFormatAlert = function () {
    var mimeType = $("#media_type_select").val();
    if (mimeType === "application/vnd.ms-excel") {
      $(".proprietary-format").removeClass("hidden");
    } else {
      $(".proprietary-format").addClass("hidden");
    }
  })();

  $('#media_type_select').change(updateMediaType);
  $('#media_type_select').change(showProprietaryFormatAlert);
});
