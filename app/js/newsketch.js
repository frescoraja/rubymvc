$(document).ready(function(){
  var color = $('.selected').css('background-color');
  var $canvas = $("canvas");
  var ctx = $canvas[0].getContext("2d");
  var lastEvent;
  var mouseDown = false;
  var strokeWeight = $('#stroke').val();

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
  });

  $('#addNewColor').click(function(e){
    var $newColor = $('<li>');
    $newColor.css("background-color", $(".newColor").css("background-color"));
    $("ul.colors").append($newColor);
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
  }).mouseleave(function() {
    $canvas.mouseup();
  });

  $('.save-button').click(function () {
    $('.save').toggleClass('up');
  });

  $("#save-form").submit(function (e) {
    e.preventDefault();
    var imgData = $canvas[0].toDataURL('image/png');
    var binary = atob(imgData.split(',')[1]);
    var array = [];
    for (var i = 0; i < binary.length; i++) {
      array.push(binary.charCodeAt(i));
    }
    var file = new Blob([new Uint8Array(array)], { type: 'image/png' });
    var fd = new FormData($("#save-form"));
    fd.append("image", file);

    $.ajax({
      url: '/sketches',
      method: 'POST',
      data: fd,
      processData: false,
      contentType: false
    });
  });
});