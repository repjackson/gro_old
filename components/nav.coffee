if Meteor.isClient
    Template.nav.events
        'click #logout': ->
            Session.set 'logging_out', true
            Meteor.logout ->
                Session.set 'logging_out', false
                Router.go '/'

        # 'click .new_item': ->
        #     console.log @
        #     new_id =
        #         Docs.insert
        #             model:'shop_item'
        #     console.log new_id
        #     # Router.go "/shop/#{new_id}/edit"
        #     Router.go "/hi"

        'click .set_model': ->
            Session.set 'loading', true
            Meteor.call 'set_facets', 'model', ->
                Session.set 'loading', false

        'click .set_post': ->
            Session.set 'loading', true
            Meteor.call 'set_facets', 'post', ->
                Session.set 'loading', false

        'click .set_bookmarked_model': ->
            Session.set 'loading', true
            Meteor.call 'set_facets', @slug, ->
                Session.set 'loading', false

    Template.nav.onRendered ->
        # @autorun =>
        #     if @subscriptionsReady()
        #         Meteor.setTimeout ->
        #             $('.dropdown').dropdown()
        #         , 3000

        # Meteor.setTimeout ->
        #     $('.item').popup(
        #         preserve:true;
        #         hoverable:true;
        #     )
        # , 3000


    Template.nav.onCreated ->
        @autorun -> Meteor.subscribe 'me'
        # @autorun -> Meteor.subscribe 'current_session'
        # @autorun -> Meteor.subscribe 'my_cart'

        @autorun -> Meteor.subscribe 'bookmarked_models'
        # @autorun -> Meteor.subscribe 'unread_messages'

    Template.nav.helpers
        notifications: ->
            Docs.find
                model:'notification'

        models: ->
            Docs.find
                model:'model'

        unread_count: ->
            unread_count = Docs.find({
                model:'message'
                to_username:Meteor.user().username
                read_by_ids:$nin:[Meteor.userId()]
            }).count()

        cart_amount: ->
            cart_amount = Docs.find({
                model:'cart_item'
                _author_id:Meteor.userId()
            }).count()

        mail_icon_class: ->
            unread_count = Docs.find({
                model:'message'
                to_username:Meteor.user().username
                read_by_ids:$nin:[Meteor.userId()]
            }).count()
            if unread_count then 'red' else ''


        bookmarked_models: ->
            if Meteor.userId()
                Docs.find
                    model:'model'
                    bookmark_ids:$in:[Meteor.userId()]

    Template.nav.onRendered ->
        # Meteor.setTimeout ->
        #     $('.context .ui.sidebar')
        #         .sidebar({
        #             context: $('.context .segment')
        #             dimPage: false
        #             transition:  'push'
        #         })
        #         .sidebar('attach events', '.context .menu .toggle_sidebar.item')
        # , 1000

    Template.nav.events


    Template.footer.events
        'click .submit_rename': ->
            old_key = $('.old_key').val()
            # new_key = $('.new_key').val()
            Meteor.call 'rename', old_key, "*#{old_key}", (err,res)->
                unless err
                    alert res


if Meteor.isServer
    Meteor.publish 'my_notifications', ->
        Docs.find
            model:'notification'
            user_id: Meteor.userId()

    Meteor.publish 'bookmarked_models', ->
        if Meteor.userId()
            Docs.find
                model:'model'
                bookmark_ids:$in:[Meteor.userId()]


    Meteor.publish 'my_cart', ->
        if Meteor.userId()
            Docs.find
                model:'cart_item'
                _author_id:Meteor.userId()

    Meteor.publish 'unread_messages', (username)->
        if Meteor.userId()
            Docs.find {
                model:'message'
                to_username:username
                read_ids:$nin:[Meteor.userId()]
            }, sort:_timestamp:-1


    Meteor.publish 'me', ->
        Meteor.users.find @userId

    Meteor.publish 'current_tribe', ->
        Docs.find
            model:'tribe'
            slug:Meteor.user().current_tribe
