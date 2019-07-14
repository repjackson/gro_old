if Meteor.isClient
    Template.library.onCreated ->
        @autorun => Meteor.subscribe 'model_docs', 'library_item'
    Template.library.helpers
        library_items: ->
            Docs.find
                model:'library_item'


    Template.shop.onCreated ->
        # @autorun => Meteor.subscribe 'model_docs', 'shop_item'
        @autorun -> Meteor.subscribe 'docs', selected_tags.array(), 'shop_item'
    Template.shop.helpers
        shop_items: ->
            Docs.find
                model:'shop_item'
    Template.shop.events
        'click .new_item': ->
            console.log @
            new_id =
                Docs.insert
                    model:'shop_item'
                    pickup_delivery:true
                    home_dropoff_delivery:true
                    building_dropoff_delivery:true
                    cash_accepted:true
                    venmo_accepted:true
                    published:true
            console.log new_id
            Router.go "/shop/#{new_id}/edit"
            # Router.go "/hi"

    Template.shop_item.events
        'click .goto_shop_item_page': ->
            Docs.update @_id,
                $inc:views:1
            Router.go "/shop/#{@_id}/view"

    Template.shop_item_page.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.shop_item_page.helpers
        doc: ->
            Docs.findOne Router.current().params.doc_id
