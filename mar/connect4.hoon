/-  *board
/+  *board
|_  b=game-state
++  grab
  |%
  ++  noun  game-state
  --
++  grow
  |%
  ++  noun  b
  ++  json
    =,  enjs:format
    %+  frond  $connect4
    %-  pairs
    :~  [%cur-player s+cur-player.b]
    [%players s+players.b]
    [%cur-player s+ss.b]
    ==

  --
--
