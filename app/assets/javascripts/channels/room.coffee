document.addEventListener 'turbolinks:load', ->
  
  if App.room
    App.cable.subscriptions.remove App.room
    
  App.room = App.cable.subscriptions.create { channel: "RoomChannel", room: $('#direct_messages').data('room_id') },
    
    #通信が確立された時
    connected: ->
      console.log('connected : room channel')
      
    #通信が切断された時
    disconnected: ->
      console.log('disconnected: room channel')
      
    rejected: ->
      console.log('rejected')
      
    #値を受け取った時
    received: (data) ->
      
      #投稿を追加
      $('#direct_messages').append data['direct_message']
      
      # スクロール量の算出
      element = document.getElementById('message-box')
      pos_top = element.getBoundingClientRect().top;
      pos_bottom = element.getBoundingClientRect().bottom;
      position = pos_bottom - pos_top　
      
      # スクロール実行
      $('html,body').delay(0).animate({scrollTop: position}, "slow")
      
    #サーバーサイドのspeakアクションにdirect_messageパラメータを渡す
    speak: (direct_message) ->
      @perform 'speak', direct_message: direct_message
      
  $('#chat-input').on 'keypress', (event) ->    # return キーのキーコードが13
  
    if event.keyCode is 13
      #speakメソッド,event.target.valueを引数に.
      App.room.speak event.target.value
      event.target.value = ''
      event.preventDefault()
      
      # チャットボックスにautofocus
      $('#chat-input').focus()
      
      # スクロール量の算出
      element = document.getElementById('message-box')
      pos_top = element.getBoundingClientRect().top;
      pos_bottom = element.getBoundingClientRect().bottom;
      position = pos_bottom - pos_top　
      
      # スクロール実行
      $('html,body').delay(0).animate({scrollTop: position}, "slow")
      