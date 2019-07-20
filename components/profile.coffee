if Meteor.isClient
    Template.user_layout.onCreated ->
        @autorun -> Meteor.subscribe 'user_from_username', Router.current().params.username
        @autorun -> Meteor.subscribe 'user_referenced_docs', Router.current().params.username
        @autorun -> Meteor.subscribe 'user_models', Router.current().params.username

    Template.user_layout.onCreated ->
        @autorun -> Meteor.subscribe 'model_docs', 'staff_resident_widget'

    Template.user_about.helpers
        staff_resident_widgets: ->
            Docs.find
                model:'staff_resident_widget'

        widget_template: ->


    Template.user_layout.helpers
        user: ->
            Meteor.users.findOne username:Router.current().params.username

        user_models: ->
            user = Meteor.users.findOne username:Router.current().params.username
            Docs.find
                model:'model'
                _id:$in:user.model_ids

        banner_style: ->
            # {
            #     background: url(/image/signup-bg.png) center no-repeat;
            #     /*height: 100%;*/
            #     width: 100%;
            #     height: 100vh;
            #     background-repeat: no-repeat;
            #     background-position: center center;
            #     background-size: cover;
            #     background-attachment: fixed;
            #     position: relative;
            # }




    Template.user_layout.events
        'click .set_delta_model': ->
            Meteor.call 'set_delta_facets', @slug, null, true

        'click .logout_other_clients': ->
            Meteor.logoutOtherClients()

        'click .logout': ->
            Meteor.logout()
            Router.go '/login'



    Template.user_array_element_toggle.helpers
        user_array_element_toggle_class: ->
            # user = Meteor.users.findOne Router.current().params.username
            if @user["#{@key}"] and @value in @user["#{@key}"] then 'active' else 'basic'
    Template.user_array_element_toggle.events
        'click .toggle_element': (e,t)->
            # user = Meteor.users.findOne Router.current().params.username
            if @user["#{@key}"]
                if @value in @user["#{@key}"]
                    Meteor.users.update @user._id,
                        $pull: "#{@key}":@value
                else
                    Meteor.users.update @user._id,
                        $addToSet: "#{@key}":@value
            else
                Meteor.users.update @user._id,
                    $addToSet: "#{@key}":@value
