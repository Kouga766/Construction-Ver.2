App.appearance = App.cable.subscriptions.create "AppearanceChannel",

  connected: ->
    console.log('connected : appearance channel')
    @install()
    @appear()

  disconnected: ->
    console.log('disconnected : appearance channel')
    @uninstall()

  rejected: ->
    @uninstall()

  appear: ->
    @perform("appear")

  away: ->
    @perform("uninstall")
    
  received: (data) ->
    if data.event is "appear"
      $("#appearance_online_" + data.customer_id).show()
      $("#appearance_offline_" + data.customer_id).hide()
      
    else if data.event is "away"
      $("#appearance_online_" + data.customer_id).hide()
      $("#appearance_offline_" + data.customer_id).show()
      
    else if data.event is "notify"
      # 自分が送信者ではない場合のみメッセージ表示処理を実行
      if String(data['sender_user'].id) != $("#current_customer_id").attr("value")
        
        # receiver_userリストの中に自分がいれば、メッセージを表示する
        for receiver_user in data['receiver_users_list']
          if String(receiver_user) == $("#current_customer_id").attr("value") 
            $('.message-body').text(data['sender_user'].name + 'さんからの新着メッセージがあります。');
            $("#myToast").toast({ delay: 3000 }).toast('show')
            $("#play-button").get(0).play()
          
  install: ->
    console.log('install')
    $(document).on "page:change.appearance", =>
      @appear()

  uninstall: ->
    console.log('uninstall')
    $(document).off(".appearance")