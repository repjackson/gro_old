if Meteor.isClient
    Template.shop_view_layout.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
        @autorun => Meteor.subscribe 'reservations_from_product_id', Router.current().params.doc_id
    Template.shop_view_layout.onRendered ->
        Meteor.setTimeout ->
            $('.button').popup()
        , 2000

    Template.shop_edit.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.shop_edit.onDestroyed ->
    Template.shop_view_layout.events
        'click .reserve_after': ->
            console.log @
            console.log Template.parentData()
            product = Docs.findOne Router.current().params.doc_id

            new_res_id = Docs.insert
                model:'reservation'
                product_id:product._id
                seller_id:product._author_id
                start_datetime: @end_datetime
            Router.go "/reservation/#{new_res_id}"
        'click .reserve': ->
            console.log @
            new_res_id = Docs.insert
                model:'reservation'
                product_id:@_id
                seller_id:@_author_id
            Router.go "/reservation/#{new_res_id}"
        'click .add_to_cart': ->
            console.log @
            Docs.insert
                model:'cart_item'
                product_id:@_id
            $('body').toast({
                title: "#{@title} added to cart."
                # message: 'Please see desk staff for key.'
                class : 'green'
                # position:'top center'
                # className:
                #     toast: 'ui massive message'
                displayTime: 5000
                transition:
                  showMethod   : 'zoom',
                  showDuration : 250,
                  hideMethod   : 'fade',
                  hideDuration : 250
                })



    Template.shop_view_layout.helpers
        active_reservation: ->
            Docs.findOne
                model:'reservation'
                product_id:Router.current().params.doc_id
                active:true

        future_reservations: ->
            now = moment(Date.now())
            Docs.find (
                model:'reservation'
                product_id:Router.current().params.doc_id
            ), sort:start_datetime:1

    Template.rentals.helpers
        active_reservation: ->
            Docs.findOne
                model:'reservation'
                product_id:Router.current().params.doc_id
                active:true

        future_reservations: ->
            now = moment(Date.now())
            Docs.find (
                model:'reservation'
                product_id:Router.current().params.doc_id
            ), sort:start_datetime:1

    Template.product_transactions.onRendered ->
        Template.children_view.onRendered ->
            Meteor.setTimeout ->
                $('.accordion').accordion()
            , 1000

    Template.product_transactions.onCreated ->
        @autorun => Meteor.subscribe 'product_transactions', Router.current().params.doc_id
    Template.product_transactions.events
        'click .add_transaction': ->
            console.log @
            Docs.insert
                model:'transaction'
                product_id: @_id
                transaction_type:'purchase'
            Meteor.call 'calculate_product_inventory_amount', @_id
    Template.product_transactions.helpers
        product_transactions: ->
            Docs.find
                model:'transaction'
                product_id: Router.current().params.doc_id


    Template.shop_stats.onCreated ->
        @autorun => Meteor.subscribe 'shop_stats', Router.current().params.doc_id
    Template.shop_stats.events
        'click .advise_price': ->
            Meteor.call 'advise_price', @_id
        'click .calculate_transaction_count': ->
            # console.log @
            Meteor.call 'calculate_product_inventory_amount', @_id
    Template.shop_stats.helpers
        product_transactions: ->
            Docs.find
                model:'transaction'
                product_id: Router.current().params.doc_id



if Meteor.isServer
    Meteor.publish 'reservations_from_product_id', (product_id)->
        Docs.find
            model:'reservation'
            product_id:product_id
