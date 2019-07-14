if Meteor.isClient
    Template.videos.onCreated ->
        @autorun -> Meteor.subscribe 'docs', selected_tags.array(), 'video'

    Template.videos.helpers
        video_items: ->
            Docs.find
                model:'video'

    Template.videos.events
        'click .new_video': ->
            new_id = Docs.insert
                model:'video'
            Router.go "/video/#{new_id}/edit"

    Template.video_card_template.events
        'click .video_card': ->
            Docs.update @_id,
                $inc:views:1
            Router.go "/video/#{@_id}"


    Template.video_page.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.video_edit.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id

    Template.video_page.helpers
        is_member: ->
            video = Docs.findOne Router.current().params.doc_id
            if video.members and Meteor.user().username in video.members then true else false

    Template.video_page.events
        'click .join': ->
            Docs.update Router.current().params.doc_id,
                $addToSet:
                    members: Meteor.user().username
        'click .leave': ->
            Docs.update Router.current().params.doc_id,
                $pull:
                    members: Meteor.user().username
