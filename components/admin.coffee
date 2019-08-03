if Meteor.isClient
    Template.user_table.onCreated ->
        @autorun ->  Meteor.subscribe 'users'


    Template.user_table.helpers
        users: -> Meteor.users.find {}


    Template.user_table.events
        'click #add_user': ->
            name = prompt 'first and last name'
            split = name.split ' '
            first_name = split[0]
            last_name = split[1]
            username = name.split(' ').join('_')
            # console.log username
            Meteor.call 'add_user', first_name, last_name, username, 'user', (err,res)=>
                if err
                    alert err
                else
                    Meteor.users.update res,
                        $set:
                            first_name:first_name
                            last_name:last_name
                    Router.go "/user/#{res.username}/edit"

    Template.user_role_toggle.helpers
        is_in_role: ->
            Template.parentData().roles and @role in Template.parentData().roles

    Template.user_role_toggle.events
        'click .add_role': ->
            parent_user = Template.parentData()
            Meteor.users.update parent_user._id,
                $addToSet:roles:@role

        'click .remove_role': ->
            parent_user = Template.parentData()
            Meteor.users.update parent_user._id,
                $pull:roles:@role



    # Template.article_list.onCreated ->
    #     @autorun ->  Meteor.subscribe 'type', 'article'
    #
    #
    # Template.article_list.helpers
    #     articles: ->
    #         Docs.find
    #             model:'article'
    #
    # Template.article_list.events
    #     'click .add_article': ->
    #         Docs.insert
    #             model:'article'
    #
    #     'click .delete_article': ->
    #         if confirm 'Delete article?'
    #             Docs.remove @_id
