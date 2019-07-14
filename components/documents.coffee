if Meteor.isClient
    Template.documents.onCreated ->
        @autorun -> Meteor.subscribe 'docs', selected_tags.array(), 'document'

    Template.documents.helpers
        document_items: ->
            Docs.find
                model:'document'

    Template.documents.events
        'click .new_document': ->
            new_id = Docs.insert
                model:'document'
            Router.go "/document/#{new_id}/edit"

    Template.document_card_template.events
        'click .document_card': ->
            Docs.update @_id,
                $inc:views:1
            Router.go "/document/#{@_id}"


    Template.document_page.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.document_page_edit.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id

    Template.document_page.helpers
        is_member: ->
            document = Docs.findOne Router.current().params.doc_id
            if document.members and Meteor.user().username in document.members then true else false

    Template.document_page.events
        'click .join': ->
            Docs.update Router.current().params.doc_id,
                $addToSet:
                    members: Meteor.user().username
        'click .leave': ->
            Docs.update Router.current().params.doc_id,
                $pull:
                    members: Meteor.user().username
