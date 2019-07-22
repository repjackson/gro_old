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
  except: ['register','forgot_password','reset_password','home','delta','doc_view','verify-email','front','shop','events']
});

Router.route '/chat', -> @render 'view_chats'
Router.route '/inbox', -> @render 'inbox'
Router.route '/register', -> @render 'register'
Router.route '/admin', -> @render 'admin'

Router.route '/shop/:product_id/daily_calendar/:month/:day/:year/', -> @render 'product_day'

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
Router.route '/forgot_password', -> @render 'forgot_password'

Router.route '/user/:username/edit', -> @render 'user_edit'
Router.route '/p/:slug', -> @render 'page'
Router.route '/settings', -> @render 'settings'
Router.route '/users', -> @render 'users'
# Router.route "/meal/:meal_id", -> @render 'meal_doc'

Router.route '/reset_password/:token', (->
    @render 'reset_password'
    ), name:'reset_password'

Router.route '/notifications', (->
    @layout 'layout'
    @render 'notifications'
    ), name:'notifications'


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


Router.route '/posts', (->
    @layout 'layout'
    @render 'posts'
    ), name:'posts'
Router.route "/post/:doc_id", (->
    @render 'post_page'
    ), name:'post_page'
Router.route "/post/:doc_id/edit", (->
    @render 'post_edit'
    ), name:'post_edit'


Router.route '/login', -> @render 'login'

# Router.route '/', -> @redirect '/'
# Router.route '/', -> @redirect "/user/#{Meteor.user().username}"

Router.route '/', (->
    @layout 'layout'
    @render 'delta'
    ), name:'home'

Router.route '/user/:username', (->
    @layout 'user_layout'
    @render 'user_about'
    ), name:'user_about'
Router.route '/user/:username/dashboard', (->
    @layout 'user_layout'
    @render 'user_dashboard'
    ), name:'user_dashboard'
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
Router.route '/user/:username/contact', (->
    @layout 'user_layout'
    @render 'user_contact'
    ), name:'user_contact'
Router.route '/user/:username/comparison', (->
    @layout 'user_layout'
    @render 'user_comparison'
    ), name:'user_comparison'
Router.route '/user/:username/notifications', (->
    @layout 'user_layout'
    @render 'user_notifications'
    ), name:'user_notifications'
