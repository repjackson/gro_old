if Meteor.isClient
    Template.user_cloud.onCreated ->
        @autorun -> Meteor.subscribe('user_tags', selected_user_tags.array())
        @autorun -> Meteor.subscribe('users_tags', selected_user_tags.array())

    Template.user_cloud.helpers
        all_user_tags: ->
            user_count = Meteor.users.find(_id:$nin:[Meteor.userId()]).count()
            console.log 'user count', user_count
            if 0 < user_count < 3 then User_tags.find({count:$lt:user_count}) else User_tags.find()

        cloud_tag_class: ->
            button_class = switch
                when @index <= 5 then 'large'
                when @index <= 12 then ''
                when @index <= 20 then 'small'
            return button_class

        selected_user_tags: -> selected_user_tags.array()

        # settings: -> {
        #     position: 'bottom'
        #     limit: 10
        #     rules: [
        #         {
        #             collection: Tags
        #             field: 'name'
        #             matchAll: true
        #             template: Template.tag_result
        #         }
        #         ]
        # }

    Template.user_cloud.events
        'click .select_tag': -> selected_user_tags.push @name
        'click .unselect_tag': -> selected_user_tags.remove @valueOf()
        'click #clear_tags': -> selected_user_tags.clear()

        'keyup #search': (e,t)->
            e.preventDefault()
            val = $('#search').val().toLowerCase().trim()
            switch e.which
                when 13 #enter
                    switch val
                        when 'clear'
                            selected_user_tags.clear()
                            $('#search').val ''
                        else
                            unless val.length is 0
                                selected_user_tags.push val.toString()
                                $('#search').val ''
                when 8
                    if val.length is 0
                        selected_user_tags.pop()

        'autocompleteselect #search': (event, template, doc) ->
            selected_user_tags.push doc.name
            $('#search').val ''


if Meteor.isServer
    Meteor.publish 'user_tags', (selected_user_tags)->
        user = Meteor.users.findOne @userId
        console.log selected_user_tags
        self = @
        match = {}
        match._id = $nin:[@userId]
        if selected_user_tags.length > 0 then match.tags = $all: selected_user_tags
        cloud = Meteor.users.aggregate [
            { $match: match }
            { $project: tags: 1 }
            { $unwind: "$tags" }
            { $group: _id: '$tags', count: $sum: 1 }
            { $match: _id: $nin: selected_user_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: 20 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        cloud.forEach (tag, i) ->
            self.added 'user_tags', Random.id(),
                name: tag.name
                count: tag.count
                index: i
        self.ready()
