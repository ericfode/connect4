/-  board
/+  *server, *server, default-agent, board
/=  c4tile-js
  /^  octs
  /;  as-octs:mimes:html
  /:  /===/app/connect4/js/tile
  /|  /js/
      /~  ~
  ==

/=  index-js
  /^  octs
  /;  as-octs:mimes:html
  /|  /:  /===/app/connect4/js/index  /js/
      /~  ~
  ==
::
/=  index
  /^  octs
  /;  as-octs:mimes:html
  /|  /:  /===/app/connect4/index  /html/
      /~  ~
  ==
::
/=  css
  /^  octs
  /;  as-octs:mimes:html
  /|  /:  /===/app/connect4/css/index  /css/
      /~  ~
  ==
::

=,  format
::
|%
::
+$  card  card:agent:gall
+$  versioned-state
  $%  state-zero
  ==
+$  state-zero  [%0 g=game-state:board]
--
=|  state-zero
=*  state  -
^-  agent:gall
=<  
  |_  =bowl:gall
  +*  this  .
      game-core  +>
      gc    ~(. game-core bowl)
      def   ~(. (default-agent this %|) bowl)
  ++  on-init
    :_  this
    :~  :*  %pass  /bind/connect4 
          %arvo  %e  %connect 
          [~ /'~connect4']  %connect4
        ==
      :*  %pass  /launch/connect4  
        %agent  [our.bol %launch]  %poke
        %launch-action  
        !>([%connect4 /c4tile '/~connect4/js/tile.js'])
      ==
    ==
  ++  on-save  !>(state)
  ++  on-load
    |=  old=vase
    ~&  old
    `this(state !<(state-zero old))

  ++  on-leave  on-leave:def
  ++  on-peek   on-peek:def
  ++  on-agent  on-agent:def
  ++  on-fail   on-fail:def
  ++  on-watch
    |=  =wire
    ^-  (quip card _this)
    ?:  ?=([%primary ~] wire)
      :_  this
      [%give %fact `/primary %connect4-game-state !>(g)]~
    ?:  ?=([%connect4tile ~] wire)
      :_  this
      [%give %fact ~ %json !>(g)]~
    ?:  ?=([%http-response *] wire)  [~ this]
    (on-watch:def wire)

  ++  on-poke
    |=  [=mark =vase]
    ^-  (quip card _this)
    =^  cards  state
      ?+  mark  (on-poke:def mark vase)
          %connect4-action
        (poke-connect4-action:gc !<(action:board vase))
          %json
        (poke-json:gc !<(json vase))
          %handle-http-request
        =+  !<([eyre-id=@ta =inbound-request:eyre] vase)
        :_  state
        %+  give-simple-payload:app  eyre-id
        %+  require-authorization:app  inbound-request
        poke-handle-http-request:gc
      ==
    [cards this]
          
  ++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card:agent:gall _this)
  ?:  ?=(%bound +<.sign-arvo)
    [~ this]
  [~ this]
  --
::
|_  bol=bowl:gall
::

++  poke-connect4-action
  |=  a=action:board
  ^-  (quip card _state)
  ?.  =(src.bol our.bol)
    [~ state]
  ~&  =(-.a %new-game)
  ?-  -.a
      %new-game
    =/  s=[x=@ y=@]  +.a
    =.  g  (new-game:play:board x.s y.s) 
    ~&  state(g g)
    :_  state
    [%give %fact `/primary %connect4-game-state !>(g)]~
      %play-move
    =/  s=@  +.a
    =+  next-state=(~(maybe-move play:board g) s)
    ?~  next-state
      `state
    =.  g  u.next-state
    :_  state
    [%give %fact `/primary %connect4-game-state !>(g)]~
  ==

++  poke-handle-http-request
  |=  =inbound-request:eyre
  ^-  simple-payload:http
  =/  request-line  (parse-request-line url.request.inbound-request)
  =/  back-path  (flop site.request-line)
  =/  name=@t
    =/  back-path  (flop site.request-line)
    ?~  back-path
      ''
    i.back-path
  ~&  request-line
  ?~  back-path
    not-found:gen
  ?+  request-line
    not-found:gen
    ::  styling
    ::
      [[[~ %css] [%'~connect4' %css %index ~]] ~]
    (css-response:gen css)
    ::  scripting
    ::
      [[[~ %js] [%'~connect4' %js %index ~]] ~]
    (js-response:gen index-js)
    ::  tile js
    ::
      [[[~ %js] [%'~connect4' %tile ~]] ~]
    (js-response:gen c4tile-js)
      [[~ [%'~connect4' ~]] ~]
    (html-response:gen index)
  ==

++  poke-json
  |=  jon=json
  ^-  (quip card _state)
  ?.  ?=(%s -.jon)
    [~ state]
  ~&  jon
  =/  str=@t  +.jon
  =/  out  *outbound-config:iris
  [~ state]
--

