if Meteor.isClient
    Template.events.onCreated ->
        @autorun -> Meteor.subscribe 'docs', selected_tags.array(), 'event'

    Template.events.helpers
        event_items: ->
            Docs.find
                model:'event'

    Template.events.events
        'click .new_event': ->
            new_id = Docs.insert
                model:'event'
            Router.go "/event/#{new_id}/edit"

    Template.event_item.events
        'click .event_card': ->
            Docs.update @_id,
                $inc:views:1
            Router.go "/event/#{@_id}"


    Template.event_page.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.event_edit.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id

    Template.event_page.helpers
        attending: ->
            event = Docs.findOne Router.current().params.doc_id
            if event.attending_usernames and Meteor.user().username in event.attending_usernames then true else false

    Template.event_page.events
        'click .mark_attending': ->
            Docs.update Router.current().params.doc_id,
                $addToSet:
                    attending_usernames: Meteor.user().username
        'click .mark_unattending': ->
            Docs.update Router.current().params.doc_id,
                $pull:
                    attending_usernames: Meteor.user().username
