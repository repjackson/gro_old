if Meteor.isClient
    Template.reservation.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
        @autorun => Meteor.subscribe 'reservation_slot_product', Router.current().params.doc_id
        @autorun => Meteor.subscribe 'reservation_product', Router.current().params.doc_id

    Template.reservation.helpers
        # next_availability:->
        #     product = Docs.findOne model:'shop_item'
        #     if
        asset:->
            Docs.findOne model:'shop_item'
        reservation:->
            Docs.findOne model:'reservation'

        # minute_duration:->
        #     res = Docs.findOne model:'reservation'
        #     res.reservation_duration
        #     moment.duration(res.reservation_duration).as('minutes')
        # hour_duration:->
        #     res = Docs.findOne model:'reservation'
        #     res.reservation_duration
        #     moment.duration(res.reservation_duration).as('hours')
        #
        # reservation_cost:->
        #     res = Docs.findOne model:'reservation'
        #     res.reservation_duration
        #     hour_duration = moment.duration(res.reservation_duration).as('hours')
        #
        #     res = Docs.findOne model:'reservation'
        #     product = Docs.findOne res.product_id
        #     # console.log product
        #     product.hourly_rate*hour_duration

        reservation_product:->
            slot = Docs.findOne Router.current().params.doc_id
            Docs.findOne
                model:'shop'
                # _id:slot.product_id

    Template.reservation_duration_preset.events
        'click .set_reservation_duration': ->
            # console.log Template.parentData().start_datetime
            parent = Template.parentData()
            new_end = moment(parent.start_datetime).add(@length, 'm').format("YYYY-MM-DD[T]HH:mm")
            start = moment(parent.start_datetime)
            end = moment(parent.end_datetime)
            duration = end.diff(start)
            # console.log duration
            hour_duration = moment.duration(duration).as('hours')
            minute_duration = moment.duration(duration).as('minutes')
            product = Docs.findOne parent.product_id
            reservation_cost = product.hourly_rate*hour_duration
            Docs.update parent._id,
                $set:
                    end_datetime:new_end
                    reservation_duration:duration
                    hour_duration:hour_duration
                    minute_duration:minute_duration
                    reservation_cost:reservation_cost


    Template.reservation.events
        # 'click .confirm_delivery': ->
        #     if confirm 'confirm delivery?'
        #         console.log 'your credits', Meteor.user().credits
        #         console.log 'seller credits', Meteor.users.findOne(@_author_id)
        #         Docs.update @_id,
        #             $set:
        #                 confirmed:true

        # 'click .cancel_reservation': ->
        #     Docs.update @_id,
        #         $set:
        #             confirmed:false
        'click .reserve_now': ->
            console.log @
            this_moment = moment(Date.now()).utcOffset(-6).format('YYYY-MM-DD[T]HH:mm')
            # this_time =  this_moment.format('HH:mm')
            # this_date =  this_moment.format('YYYY-MM-DD')
                # format("YYYY-MM-DD[T]HH:mm
            # console.log this_time
            # console.log this_date
            Docs.update @_id,
                $set:
                    start_datetime:this_moment
        'click .check_availability': ->
            Meteor.call 'check_availability', Router.current().params.doc_id

        # 'click .new_reservation': ->
        #     slot = Docs.findOne model:'reservation_slot'
        #     Docs.insert
        #         model:'reservation'
        #         parent_slot:slot._id
        #         date:slot.date
        #     console.log Template.parentData()

        # 'click .mark_delivered': ->
        #     console.log @
        #     if confirm 'mark delivery ended?'
        #         Docs.update @_id,
        #             $set:
        #                 delivery_ended_timestamp:Date.now()
        #                 status:'delivery ended'
        #                 delivery_ended:true
        #
        # 'click .mark_complete': ->
        #     if confirm 'mark reservation ended?'
        #         Docs.update @_id,
        #             $set:
        #                 reservation_ended_timestamp:Date.now()
        #                 status:'reservation marked complete'
        #                 reservation_ended:true
        'click .confirm': ->
            console.log @
            Docs.update @_id,
                $set:
                    confirmed:true
                    active:true

        'click .unconfirm': ->
            console.log @
            Docs.update @_id,
                $set:
                    confirmed:false
                    active:false


    Template.reservation_product_template.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.reservation_product_template.helpers
        s: ->
            console.log @
        reservation_product:->
            Docs.findOne Router.current().params.doc_id

if Meteor.isServer
    # Meteor.publish 'reservation_slot_product', (slot_id)->
    #     slot = Docs.findOne slot_id
    #     Docs.find
    #         model:'shop'
    #         _id:slot.product_id

    Meteor.publish 'reservation_product', (reservation_id)->
        reservation = Docs.findOne reservation_id
        res = Docs.find(
            _id:reservation.product_id
            )

    Meteor.methods
        check_availability: (doc_id)->
            reservation = Docs.findOne doc_id
            this_moment = moment(Date.now())

            product = Docs.findOne _id:reservation.product_id
            current_res = Docs.findOne
                model:'reservation'
                product_id:product._id
                active:true
            if current_res
                console.log 'not available'
                Docs.update product._id,
                    $set:
                        available:false
            else
                console.log 'available!'
                Docs.update product._id,
                    $set:
                        available:true
