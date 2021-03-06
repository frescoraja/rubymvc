$(document).ready(function(){
  var color = $('.selected').css('background-color');
  var $canvas = $("canvas");
  var ctx = $canvas[0].getContext("2d");
  var lastEvent;
  var startedDrawing = false;
  var mouseDown = false;
  var strokeWeight = $('#stroke').val();
  $("button.save-btn").prop("disabled", true);

  $('.revealColorSelect').click(function() {
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
    startedDrawing = false;
  });

  $('#addNewColor').click(function(){
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
    if (!startedDrawing) {
      $("button.save-btn").prop("disabled", false);
      startedDrawing = true;
    }

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
  }).mouseleave(function(e) {
    if (mouseDown) {
      ctx.moveTo(lastEvent.offsetX, lastEvent.offsetY);
      ctx.lineTo(e.offsetX, e.offsetY);
      ctx.lineWidth = strokeWeight;
      ctx.stroke();
    }
    lastEvent = e;
  }).mouseenter(function(e) {
    if (e.buttons === 1) {
      mouseDown = true;
    }
    lastEvent = e;
  });

  $('body').on('mouseup', function() {
    mouseDown = false;
  });


  $('.save-icon').click(function () {
    $('revealColorSelect').removeClass('on');
    $('colorSelect').removeClass('shown');
    $('.saving').toggleClass('open');
  });

  $("#save-form").submit(function (e) {
    var imgData = $canvas[0].toDataURL('image/png');
    var sketchData = $("#save-form").serializeJSON();

    e.preventDefault();
    $('button.save-btn').prop('disabled', true);
    sketchData.sketch.image = imgData;

    $.ajax({
      url: '/sketches',
      method: 'POST',
      data: sketchData,
      dataType: 'json',
      complete: function() {
        window.location = "/";
      }
    });
  });
});
