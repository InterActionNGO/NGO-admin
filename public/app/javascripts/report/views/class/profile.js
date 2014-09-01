'use strict';

define([
  'underscore',
  'backbone',
  'handlebars',
  'models/profile',
  'text!templates/profile.handlebars'
], function(_, Backbone, Handlebars, ProfileModel, tpl) {

  var ProfileView = Backbone.View.extend({

    model: new ProfileModel(),

    template: Handlebars.compile(tpl),

    render: function() {
      console.log(this.model.toJSON());
      this.$el.html(this.template( this.model.toJSON() ));
    },

    getProfile: function(params) {
      this.model.getByParams(params, _.bind(function() {
        this.render();
      }, this));
    }

  });

  return ProfileView;

});
