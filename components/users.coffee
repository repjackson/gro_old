if Meteor.isClient
    Template.users.onCreated ->
        @autorun -> Meteor.subscribe('users')
        @autorun => Meteor.subscribe 'user_search', Session.get('username_query')


    Template.users.helpers
        users: ->
            username_query = Session.get('username_query')
            if username_query
                Meteor.users.find({
                    username: {$regex:"#{username_query}", $options: 'i'}
                    # roles:$in:['resident','owner']
                    },{ limit:20 }).fetch()
            else
                Meteor.users.find({})

    Template.users.events
        # 'click #add_user': ->
        #     id = Docs.insert model:'person'
        #     Router.go "/person/edit/#{id}"
        'keyup .username_search': (e,t)->
            username_query = $('.username_search').val()
            if e.which is 8
                if username_query.length is 0
                    Session.set 'username_query',null
                    Session.set 'checking_in',false
                else
                    Session.set 'username_query',username_query
            else
                Session.set 'username_query',username_query


    Template.user.events
        'click .delete_user': ->
            console.log @
            Meteor.users.remove @_id


if Meteor.isServer
    Meteor.publish 'users', (limit)->
        if limit
            Meteor.users.find({},limit:limit)
        else
            Meteor.users.find()


    Meteor.publish 'user_search', (username)->
        Meteor.users.find({
            username: {$regex:"#{username}", $options: 'i'}
            },{ limit:20})
