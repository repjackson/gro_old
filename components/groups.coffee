if Meteor.isClient
    Template.groups.onCreated ->
        @autorun -> Meteor.subscribe 'docs', selected_tags.array(), 'group'

    Template.groups.helpers
        group_items: ->
            Docs.find
                model:'group'

    Template.groups.events
        'click .new_group': ->
            new_id = Docs.insert
                model:'group'
            Router.go "/group/#{new_id}/edit"

    Template.group_item.events
        'click .group_card': ->
            Docs.update @_id,
                $inc:views:1
            Router.go "/group/#{@_id}"


    Template.group_page.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.group_edit.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id

    Template.group_page.helpers
        is_member: ->
            group = Docs.findOne Router.current().params.doc_id
            if group.members and Meteor.user().username in group.members then true else false

    Template.group_page.events
        'click .join': ->
            Docs.update Router.current().params.doc_id,
                $addToSet:
                    members: Meteor.user().username
        'click .leave': ->
            Docs.update Router.current().params.doc_id,
                $pull:
                    members: Meteor.user().username
