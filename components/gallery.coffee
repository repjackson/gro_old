if Meteor.isClient
    Template.gallery.onRendered ->
        # Meteor.setTimeout ->
        #     $('.accordion').accordion()
        # , 1000

    Template.gallery.onCreated ->
        # @autorun -> Meteor.subscribe 'gallery'
        @autorun -> Meteor.subscribe 'docs', selected_tags.array(), 'image'
    Template.gallery.helpers
        images: ->
            Docs.find
                model:'image'

    Template.gallery.events
        'click .add_image': ->
            new_id = Docs.insert
                model:'image'
            Router.go "/image/#{new_id}/edit"

    Template.image_card_template.events
        'click .image_item': ->
            Docs.update @_id,
                $inc:views:1
            Router.go "/image/#{@_id}"



    Template.image_edit_page.events
        'click .delete_image': ->
            if confirm 'delete image?'
                Docs.remove @_id
                Router.go "/gallery"

    Template.image_page.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.image_edit_page.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id

    Template.image_page.helpers

    Template.image_page.events






if Meteor.isServer
    Meteor.publish 'gallery', ->
        Docs.find
            model:'gallery'
            active:true
