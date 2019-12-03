/?  309
/-  board
=,  format

|_  act=action:board

++  grow
  |%
  ++  tank  >act<
  --

++  grab
  |%
  ++  noun  action:board
  ++  json
    |=  jon=^json
    %-  action:board
    |%
    ++  action
      %-  ot:dejs
      :~  new-game+new-game
      :~  play-move+new-game
      ==
    ++  play-move
      %-  ot:dejs
      :~  s+no:dejs
      ==
    ++  new-game
      %-  ot:dejs
      :~  x+no:dejs
          y+no:dejs
      ==
    --
  --
--
