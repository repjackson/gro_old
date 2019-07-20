if Meteor.isClient
    Template.post_item.events
        'click .post_card': ->
            Docs.update @_id,
                $inc:views:1
            Router.go "/post/#{@_id}"


    Template.post_page.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.post_edit.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id


    Template.related_posts.onCreated ->
        @autorun => Meteor.subscribe 'related_posts', Router.current().params.doc_id
    Template.related_posts.helpers
        related_posts: ->
            doc_id = Router.current().params.doc_id
            post = Docs.findOne doc_id
            if post.related_ids
                Docs.find
                    _id:$in:post.related_ids

    Template.related_posts.events
        'click .calculate': ->
            Meteor.call 'related_posts', Router.current().params.doc_id


if Meteor.isServer
    Meteor.methods
        related_posts: (doc_id)->
            post = Docs.findOne doc_id
            unless post.matches
                Docs.update doc_id,
                    $set:matches:[]
            related_ids = []

            matches = post.matches
            related_posts_with_counts = []
            # console.log 'finding matches for ', post
            for tag in post.tags
                found_matches = Docs.find
                    _id:$ne:doc_id
                    tags:$in:[tag]
                if found_matches.fetch().length > 0
                    for found_match in found_matches.fetch()
                        related_ids.push found_match._id
                        match_subobject = _.where(matches, {doc_id: found_match._id})
                        console.log 'match subobject', match_subobject
                        if match_subobject.length > 0
                            Docs.update { _id:doc_id, "matches.doc_id":found_match._id},
                                $inc: "matches.$.tag_match_count": 1
                        else
                            match_subobject = {doc_id:found_match._id,tag_match_count:1}
                            Docs.update _id:doc_id,
                                $addToSet: "matches": match_subobject

                # console.log 'found match with ', tag, found_matches.fetch()
            console.log 'related ids', related_ids
            Docs.update doc_id,
                $set:related_ids:related_ids



    Meteor.publish 'related_posts', (doc_id)->
        post = Docs.findOne doc_id
        if post.related_ids
            Docs.find
                _id:$in:post.related_ids
