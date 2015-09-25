$(document).ready(function(){
  var color = $('.selected').css('background-color');
  var $canvas = $("canvas");
  var ctx = $canvas[0].getContext("2d");
  var lastEvent;
  var mouseDown = false;
  var strokeWeight = $('#stroke').val();
  $("button.save-btn").prop("disabled", true);

  $('.revealColorSelect').click(function(e) {
    $(".colorSelect").toggleClass("shown");
    $(this).toggleClass("on");
  });

  $('ul.colors').on('click', 'li', function(e){
    $('.selected').removeClass('selected');
    $(e.target).addClass('selected');
    color = $(e.target).css('background-color');
  });

  $('.sliders input[type=range]').change(changeColor);

  $('#stroke').change(changeStrokeWeight);

  $('#clear').click(function () {
    ctx.clearRect(0, 0, $canvas[0].width, $canvas[0].height);
    $("button.save-btn").prop("disabled", true);
  });

  $('#addNewColor').click(function(e){
    var $newColor = $('<li>').css('display', 'none');
    $newColor.css("background-color", $(".newColor").css("background-color"));
    $("ul.colors").append($newColor);
    $newColor.fadeIn();
    $newColor.click();
  });

  function changeStrokeWeight () {
    strokeWeight = $("#stroke").val();
  }

  function changeColor () {
    var r = $("#red").val();
    var b = $("#blue").val();
    var g = $("#green").val();
    var colorString = "rgb(" + r + "," + g + "," + b + ")";
    $("div.newColor").css("background-color", colorString);
  }

  $canvas.mousedown(function(e) {
    $("button.save-btn").prop("disabled", false);
    lastEvent = e;
    mouseDown = true;
  }).mousemove(function(e){
    if (mouseDown) {
      ctx.beginPath();
      ctx.moveTo(lastEvent.offsetX, lastEvent.offsetY);
      ctx.lineTo(e.offsetX, e.offsetY);
      ctx.strokeStyle = color;
      ctx.lineWidth = strokeWeight;
      ctx.stroke();
      lastEvent = e;
    }
  }).mouseup(function() {
    mouseDown = false;
  }).mouseleave(function(e) {
    $canvas.mouseup();
  });

  $('.save-icon').click(function () {
    $('revealColorSelect').removeClass('on');
    $('colorSelect').removeClass('shown');
    $('.save').toggleClass('up');
  });

  $("#save-form").submit(function (e) {
    e.preventDefault();
    $('button.save-btn').prop('disabled', true);
    var imgData = $canvas[0].toDataURL('image/png');
    var sketchData = $("#save-form").serializeJSON();
    sketchData.sketch.image = imgData;

    $.ajax({
      url: '/sketches',
      method: 'POST',
      data: sketchData,
      dataType: 'json',
      complete: function(req, res) {
        window.location = "/";
      }
    });
  });
});
