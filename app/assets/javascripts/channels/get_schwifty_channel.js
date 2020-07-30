//= require get_schwifty
//= require action_cable
//= require_self
(function() {
  this.App || (this.App = {});
  App.cable = ActionCable.createConsumer();
}).call(this);

//OLD// //= require get_schwifty
//OLD// document.addEventListener("DOMContentLoaded", function() {
//OLD//   GetSchwifty(App).showMeWhatYouGot();
//OLD// });
