
Meteor.users.allow
    update: (userId, doc, fields, modifier) ->
        true
    remove: (userId, doc, fields, modifier) ->
        true
        # if userId and doc._id == userId
        #     true

Cloudinary.config
    cloud_name: 'facet'
    api_key: Meteor.settings.private.cloudinary_key
    api_secret: Meteor.settings.private.cloudinary_secret


Meteor.publish 'model_docs', (model,limit)->
    if limit
        Docs.find {
            model: model
        }, limit:limit
    else
        Docs.find
            model: model

Meteor.publish 'document_by_slug', (slug)->
    Docs.find
        model: 'document'
        slug:slug

Meteor.publish 'child_docs', (id)->
    Docs.find
        parent_id:id


Meteor.publish 'facet_doc', (tags)->
    split_array = tags.split ','
    Docs.find
        tags: split_array


Meteor.publish 'inline_doc', (slug)->
    Docs.find
        model:'inline_doc'
        slug:slug


Meteor.publish 'user_from_username', (username)->
    Meteor.users.find username:username

Meteor.publish 'user_from_id', (user_id)->
    Meteor.users.find user_id

Meteor.publish 'author_from_doc_id', (doc_id)->
    doc = Docs.findOne doc_id
    Meteor.users.find user_id

Meteor.publish 'page', (slug)->
    Docs.find
        model:'page'
        slug:slug

Meteor.publish 'page_children', (slug)->
    page = Docs.findOne
        model:'page'
        slug:slug
    Docs.find
        parent_id:page._id



Meteor.publish 'page_blocks', (slug)->
    page = Docs.findOne
        model:'page'
        slug:slug
    if page
        Docs.find
            parent_id:page._id


# Meteor.publish 'doc_tags', (selected_tags)->
#     self = @
#     match = {}
#     match.tags = $all: selected_tags
#
#     cloud = Docs.aggregate [
#         { $match: match }
#         { $project: tags: 1 }
#         { $unwind: "$tags" }
#         { $group: _id: '$tags', count: $sum: 1 }
#         { $match: _id: $nin: selected_tags }
#         { $sort: count: -1, _id: 1 }
#         { $limit: 50 }
#         { $project: _id: 0, name: '$_id', count: 1 }
#         ]
#     cloud.forEach (tag, i) ->
#         self.added 'tags', Random.id(),
#             name: tag.name
#             count: tag.count
#             index: i
#     self.ready()
