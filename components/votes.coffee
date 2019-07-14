if Meteor.isClient
    Template.votes.onCreated ->
        @autorun -> Meteor.subscribe 'docs', selected_tags.array(), 'vote'

    Template.votes.helpers
        vote_items: ->
            Docs.find
                model:'vote'

    Template.votes.events
        'click .new_vote': ->
            new_id = Docs.insert
                model:'vote'
            Router.go "/vote/#{new_id}/edit"

    Template.vote_item.events
        'click .vote_card': ->
            Docs.update @_id,
                $inc:views:1
            Router.go "/vote/#{@_id}"


    Template.vote_page.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.vote_edit.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id

    Template.vote_page.helpers
        is_member: ->
            vote = Docs.findOne Router.current().params.doc_id
            if vote.members and Meteor.user().username in vote.members then true else false

    Template.vote_page.events
        'click .join': ->
            Docs.update Router.current().params.doc_id,
                $addToSet:
                    members: Meteor.user().username
        'click .leave': ->
            Docs.update Router.current().params.doc_id,
                $pull:
                    members: Meteor.user().username
