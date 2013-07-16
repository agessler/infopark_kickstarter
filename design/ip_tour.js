

jQuery.fn.center = function() {
  if (this.length === 1) {
    this.css({
      marginLeft: -this.innerWidth() / 2,
      marginTop: -this.innerHeight() / 2,
      left: '50%',
    });
  }
};

function ip_tour_modal() {
  $('.ip_tour_overlay').toggleClass('show');
  $('#ip_tour_modal').toggleClass('show');
  $('#ip_tour_modal').center();
}




$(document).ready(function() {


  $('.ip_sub_nav_vertical li a').click(function (e) {
  e.preventDefault();
  $(this).tab('show');
  });



$(window).resize(function() {
  $('#ip_tour_modal.show').center();

});



});





