App.syncs = App.cable.subscriptions.create "SyncsChannel",
  collection: -> $("[data-channel='syncs']")

#*DTA TODO WRAP UP HERE
  connected: ->
    console.log 'syncs.coffee: connected() called'
    # FIXME: While we wait for cable subscriptions to always be finalized before sending messages
    setTimeout =>
      @followCurrentSync()
      @installPageChangeCallback()
    , 1000

  received: (data) ->
    console.log 'syncs.coffee: received() data: ' + data
    @collection().append(data.sync) # unless @userIsCurrentUser(data.comment) #*DTA Should probably only add if IS current user

  # userIsCurrentUser: (comment) ->
  #  $(comment).attr('data-user-id') is $('meta[name=current-user]').attr('id')

  followCurrentSync: ->
    if userId = @collection().data('user-id')
      console.log 'syncs.coffee: followCurrentSync() follow userId: ' + userId
      @perform 'follow', user_id: userId
    else
      console.log 'syncs.coffee: followCurrentSync() unfollow'
      @perform 'unfollow'

  installPageChangeCallback: ->
    unless @installedPageChangeCallback
      @installedPageChangeCallback = true
      $(document).on 'turbolinks:load', -> App.syncs.followCurrentSync()
