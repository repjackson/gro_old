if Meteor.isClient
    Template.user_messages.onCreated ->
        @autorun => Meteor.subscribe 'user_messages',Router.current().params.username
        @autorun => Meteor.subscribe 'users'



    Template.user_messages.helpers
        user_messages: ->
            current_user = Meteor.users.findOne username:Router.current().params.username
            Docs.find {
                model:'message'
                to_username:current_user.username
            }, sort:_timestamp:-1

    Template.user_messages.events
        'keyup #new_message': (e,t)->
            if e.which is 13
                body = t.$('#new_message').val().trim()
                console.log body
                current_user = Meteor.users.findOne username:Router.current().params.username
                Docs.insert
                    body:body
                    model:'message'
                    to_user_id:current_user._id
                    to_username:current_user.username

                t.$('#new_message').val('')


    Template.notify_message.events
        'click .notify': (e,t)->
            current_user = Meteor.users.findOne username:Router.current().params.username
            Docs.insert
                model:'log_event'
                body:"#{current_user.username} was notified about message: #{@body} by #{Meteor.user().username}."
                user_ids:[current_user._id,Meteor.userId()]
                to_user_id:current_user._id
                to_username:current_user.username
            Meteor.call 'notify_message', @_id


if Meteor.isServer
    Meteor.publish 'user_messages', (username)->
        match = {}
        match.model = 'message'
        match.to_username = username
        Docs.find match
    Meteor.publish 'assigned_tasks', (username)->
        match = {}
        match.model = 'task'
        # match.to_username = username
        Docs.find match
