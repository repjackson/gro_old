Router.configure
    layoutTemplate: 'layout'
    notFoundTemplate: 'not_found'
    loadingTemplate: 'splash'
    trackPageView: true

force_loggedin =  ()->
    if !Meteor.userId()
        @render 'login'
    else
        @next()

Router.onBeforeAction(force_loggedin, {
  # only: ['admin']
  # except: ['register', 'forgot_password','reset_password','front','delta','doc_view','verify-email']
  except: ['register','forgot_password','reset_password','delta','doc_view','verify-email','front','shop','events']
});

Router.route '/add_karma', -> @render 'add_karma'
Router.route '/credit', -> @render 'credit'
Router.route '/transactions', -> @render 'transactions'
Router.route '/my_transactions', -> @render 'my_transactions'
Router.route '/chat', -> @render 'view_chats'
Router.route '/inbox', -> @render 'inbox'
Router.route '/register', -> @render 'register'
Router.route '/cart', -> @render 'cart'
Router.route '/tab', -> @render 'tab'
Router.route '/admin', -> @render 'admin'
Router.route '/dashboard', -> @render 'dashboard'
Router.route '/games', -> @render 'games'
Router.route '/deliveries', -> @render 'deliveries'

Router.route '/library', (->
    @layout 'layout'
    @render 'library'
    ), name:'library'

Router.route '/food', (->
    @layout 'layout'
    @render 'food'
    ), name:'food'

Router.route '/gallery', (->
    @layout 'layout'
    @render 'gallery'
    ), name:'gallery'
Router.route "/image/:doc_id", (->
    @render 'image_page'
    ), name:'image_page'
Router.route "/image/:doc_id/edit", (->
    @render 'image_edit_page'
    ), name:'image_edit_page'







Router.route "/shop", (->
    @layout 'layout'
    @render 'shop'
    ), name:'shop'


Router.route '/shop/:product_id/daily_calendar/:month/:day/:year/', -> @render 'product_day'
Router.route '/game/:game_slug', -> @render 'game'

Router.route('enroll', {
    path: '/enroll-account/:token'
    template: 'reset_password'
    onBeforeAction: ()=>
        Meteor.logout()
        Session.set('_resetPasswordToken', this.params.token)
        @subscribe('enrolledUser', this.params.token).wait()
})


Router.route('verify-email', {
    path:'/verify-email/:token',
    onBeforeAction: ->
        console.log @
        # Session.set('_resetPasswordToken', this.params.token)
        # @subscribe('enrolledUser', this.params.token).wait()
        console.log @params
        Accounts.verifyEmail(@params.token, (err) =>
            if err
                console.log err
                alert err
                @next()
            else
                alert 'email verified'
                @next()
                # Router.go "/user/#{Meteor.user().username}"
        )
})


Router.route '/m/:model_slug', (->
    @render 'delta'
    ), name:'delta'
Router.route '/m/:model_slug/:doc_id/edit', -> @render 'model_doc_edit'
Router.route '/m/:model_slug/:doc_id/view', (->
    @render 'model_doc_view'
    ), name:'doc_view'
Router.route '/model/edit/:doc_id', -> @render 'model_edit'

# Router.route '/user/:username', -> @render 'user'
# Router.route '/user/:username/m/:type', -> @render 'profile_layout', 'user_section'
Router.route '/add_resident', (->
    @layout 'layout'
    @render 'add_resident'
    ), name:'add_resident'
Router.route '/forgot_password', -> @render 'forgot_password'

Router.route '/user/:username/edit', -> @render 'user_edit'
Router.route '/p/:slug', -> @render 'page'
Router.route '/settings', -> @render 'settings'
Router.route '/users', -> @render 'users'
# Router.route "/meal/:meal_id", -> @render 'meal_doc'

Router.route "/meal/:doc_id/view", (->
    @render 'meal_view'
    ), name:'meal_view'
Router.route "/meal/:doc_id/edit", (->
    @render 'meal_edit'
    ), name:'meal_edit'


Router.route '/reset_password/:token', (->
    @render 'reset_password'
    ), name:'reset_password'

Router.route "/reservation/:doc_id/", (->
    @render 'reservation'
    ), name:'reservation'


Router.route '/events', (->
    @layout 'layout'
    @render 'events'
    ), name:'events'
Router.route "/event/:doc_id", (->
    @render 'event_page'
    ), name:'event_page'
Router.route "/event/:doc_id/edit", (->
    @render 'event_edit'
    ), name:'event_edit'


Router.route '/notifications', (->
    @layout 'layout'
    @render 'notifications'
    ), name:'notifications'




Router.route '/votes', (->
    @layout 'layout'
    @render 'votes'
    ), name:'votes'
Router.route "/vote/:doc_id", (->
    @render 'vote_page'
    ), name:'vote_page'
Router.route "/vote/:doc_id/edit", (->
    @render 'vote_edit'
    ), name:'vote_edit'


Router.route '/documents', (->
    @layout 'layout'
    @render 'documents'
    ), name:'documents'
Router.route "/document/:doc_id", (->
    @render 'document_page'
    ), name:'document_page'
Router.route "/document/:doc_id/edit", (->
    @render 'document_page_edit'
    ), name:'document_page_edit'


Router.route '/groups', (->
    @layout 'layout'
    @render 'groups'
    ), name:'groups'
Router.route "/group/:doc_id", (->
    @render 'group_page'
    ), name:'group_page'
Router.route "/group/:doc_id/edit", (->
    @render 'group_edit'
    ), name:'group_edit'


Router.route '/videos', (->
    @layout 'layout'
    @render 'videos'
    ), name:'videos'
Router.route "/video/:doc_id", (->
    @render 'video_page'
    ), name:'video_page'
Router.route "/video/:doc_id/edit", (->
    @render 'video_edit'
    ), name:'video_edit'


Router.route "/shop/:doc_id/view", (->
    @layout 'shop_view_layout'
    @render 'shop_info'
    ), name:'shop_view_info'
Router.route "/shop/:doc_id/info", (->
    @layout 'shop_view_layout'
    @render 'shop_info'
    ), name:'shop_info'
Router.route "/shop/:doc_id/rentals", (->
    @layout 'shop_view_layout'
    @render 'shop_rentals'
    ), name:'shop_rentals'
Router.route "/shop/:doc_id/earnings", (->
    @layout 'shop_view_layout'
    @render 'shop_earnings'
    ), name:'shop_earnings'
Router.route "/shop/:doc_id/chat", (->
    @layout 'shop_view_layout'
    @render 'shop_chat'
    ), name:'shop_chat'
Router.route "/shop/:doc_id/projections", (->
    @layout 'shop_view_layout'
    @render 'shop_projections'
    ), name:'shop_projections'
Router.route "/shop/:doc_id/ownership", (->
    @layout 'shop_view_layout'
    @render 'product_ownership'
    ), name:'product_ownership'
Router.route "/shop/:doc_id/ads", (->
    @layout 'shop_view_layout'
    @render 'product_ads'
    ), name:'product_ads'
Router.route "/shop/:doc_id/tasks", (->
    @layout 'shop_view_layout'
    @render 'shop_tasks'
    ), name:'shop_tasks'
Router.route "/shop/:doc_id/stats", (->
    @layout 'shop_view_layout'
    @render 'shop_stats'
    ), name:'shop_stats'
Router.route "/shop/:doc_id/edit", (->
    @render 'shop_edit'
    ), name:'shop_edit'



Router.route '/login', -> @render 'login'

# Router.route '/', -> @redirect '/m/model'
# Router.route '/', -> @redirect "/user/#{Meteor.user().username}"
Router.route '/home', -> @render 'home'

Router.route '/', (->
    @layout 'layout'
    @render 'shop'
    ), name:'front'

Router.route '/user/:username', (->
    @layout 'user_layout'
    @render 'user_about'
    ), name:'user_about'
Router.route '/user/:username/karma', (->
    @layout 'user_layout'
    @render 'user_karma'
    ), name:'user_karma'
Router.route '/user/:username/payment', (->
    @layout 'user_layout'
    @render 'user_payment'
    ), name:'user_payment'
Router.route '/user/:username/votes', (->
    @layout 'user_layout'
    @render 'user_votes'
    ), name:'user_votes'
Router.route '/user/:username/dashboard', (->
    @layout 'user_layout'
    @render 'user_dashboard'
    ), name:'user_dashboard'
Router.route '/user/:username/requests', (->
    @layout 'user_layout'
    @render 'user_requests'
    ), name:'user_requests'
Router.route '/user/:username/tags', (->
    @layout 'user_layout'
    @render 'user_tags'
    ), name:'user_tags'
Router.route '/user/:username/transactions', (->
    @layout 'user_layout'
    @render 'user_transactions'
    ), name:'user_transactions'
Router.route '/user/:username/gallery', (->
    @layout 'user_layout'
    @render 'user_gallery'
    ), name:'user_gallery'
Router.route '/user/:username/bookmarks', (->
    @layout 'user_layout'
    @render 'user_bookmarks'
    ), name:'user_bookmarks'
Router.route '/user/:username/documents', (->
    @layout 'user_layout'
    @render 'user_documents'
    ), name:'user_documents'
Router.route '/user/:username/social', (->
    @layout 'user_layout'
    @render 'user_social'
    ), name:'user_social'
Router.route '/user/:username/events', (->
    @layout 'user_layout'
    @render 'user_events'
    ), name:'user_events'
Router.route '/user/:username/contact', (->
    @layout 'user_layout'
    @render 'user_contact'
    ), name:'user_contact'
Router.route '/user/:username/products', (->
    @layout 'user_layout'
    @render 'user_products'
    ), name:'user_products'
Router.route '/user/:username/comparison', (->
    @layout 'user_layout'
    @render 'user_comparison'
    ), name:'user_comparison'
Router.route '/user/:username/notifications', (->
    @layout 'user_layout'
    @render 'user_notifications'
    ), name:'user_notifications'
