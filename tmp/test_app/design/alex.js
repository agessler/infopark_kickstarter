

jQuery.fn.center = function() {
  if (this.length === 1) {
    this.css({
      marginLeft: -this.innerWidth() / 2,
      marginTop: -this.innerHeight() / 2,
      left: '50%',
    });
  }
};

function editing_mediabrowser_toggle() {
  $('.editing-overlay').toggleClass('show');
  $('#editing-mediabrowser').toggleClass('show');
  $('#editing-mediabrowser').center();
}




$(document).ready(function() {





$(window).resize(function() {
  $('#editing-mediabrowser.show').center();

});



});





