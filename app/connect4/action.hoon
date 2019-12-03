/?  309
/-  board
=,  format

|_  act=action:board
++  grow
  |%
  ++  tank  >act<
  --

++ grab
  |%
  ++ noun  action:board
  ++ json
    |=  jon=^json
    %-  action:board
    |%
    ++  action
      %-  of:dejs
      :~  new-game+new-game
      ==
    ++  new-game
      %-  ot:dejs
      :~  x+no:dejs
          y+no:dejs
      ==
    --
  --
--
