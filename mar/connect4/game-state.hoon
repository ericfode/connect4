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
    =+  got=~(got by b.b)
    %+  frond  %connect4-game-state
    %-  pairs
    :~  [%cur-player s+cur-player.b]
      :-  %players
        %-  pairs
          :~  [%a (ship a.players.b)]
            [%b (ship b.players.b)]
          ==
      :+  %cords  %a
        %+  turn  cords.b
          |=  [x=@ y=@]
          %-  pairs
            :~  [%x (numb x)]
                [%y (numb y)]
            ==
      :+  %state  %a
        %+  turn  cords.b
          |=(at=[x=@ y=@] [%s (got at)])
      :+  %ss  %a
        %+  turn  ss.b
          |=  v=@  (numb v)
      :-  %size
        %-  pairs
          :~  x+(numb x.size.b)
            y+(numb y.size.b)
          ==
    ==
  --
--
