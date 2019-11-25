/-  *board
!:
|%
::
++  new-cords
  :: builds a list of all of the slots
  :: in this board
  ::
  |=  [sizex=@ sizey=@]
  ^-  (list cord)
  =+  xs=(gulf 0 sizex)
  =+  ys=(gulf 0 sizey)
  %:  zing
    %:  turn  xs
      |=  ax=@
      ^-  (list cord)
      %:  turn  ys
        |=  ay=@
        ^-  cord
        [x=ax y=ay]
      ==
    ==
  ==
::
++  new-board
  ::  buids a new board  of a given list of 
  ::  cords
  ::
  |=  [cords=(list cord)]
  ^-  board
  %:  my
    %:  turn  cords
      |=  [c=cord]
      ^-  (pair cord state)
      [c %empty]
    ==
  ==
::
++  new-slot-state
  ::  Generates a new slot state given a size
  ::
  |=  [sizex=@ sizey=@]
  (reap +(sizex) +(sizey))
::
++  play
  |_  g=game-state
  ++  new-game
    ::  create a new game
    ::
    |=  [sx=@ sy=@]
    ^-  game-state
    =+  sizex=(dec sx)
    =+  sizey=(dec sy)
    =+  cs=(new-cords sizex sizey)
    =+  bs=(new-board cs)
    =/  =players  [a=~nec b=~bud]
    %_  g
      cords  cs
      b  bs
      ss              (new-slot-state sizex sizey)
      size            [x=+(sizex) y=+(sizey)]
      cur-player      %a
      players         players
    == 
  ::
  ++  next-player
    ::  switches player 
    ::
    |.
      ?:  =(%a cur-player.g)  
        %b
      %a
  ::
  ++  can-move
    ::  Takes a location and returns bool 
    ::  if you can move there
    ::  
    |=  [movex=@]
    ?&  (lth movex x.size.g)
      (gth (snag movex ss.g) 0)
      ==
  ::
  ++  move
    ::  Assumes a move can be made and returns a board
    ::
    |=  [movex=@]
    ^-  game-state
    =+  slot=(snag movex ss.g)
    =+  open=(sub y.size.g slot)
    =/  target=cord  [x=movex y=open] 
    %_  g
      ss          (snap ss.g movex (dec slot))
      cur-player  (next-player)
      b           (~(put by b.g) target cur-player.g)
    ==
  ::
  ++  add-loc
    ::  adds a direction to a location
    ::
    |=  [dp=[@s @s] loc=[@s @s]]
    ^-  [@s @s]
    [(add +2.dp +2.loc) (add +3.dp +3.loc)]
  ::
  ++  past-edge
    ::  checks if a location is psased the edge of the
    ::  board in any direction
    ::
    |=  [loc=[@s @s]]
    ^-  _|
    ?|  =((cmp:si +.loc --0) -1)
        =((cmp:si -.loc --0) -1)
        =((cmp:si +.loc x.size.g) --1)
        =((cmp:si -.loc y.size.g) --1)
    ==
  ::
  ++  at-edge-in-dir
    ::  detects if target is at the edge in a direction
    ::
    |=  [dp=[@s @s] target=[@s @s]]
    ^+  |
    =+  next-loc=(add-loc target dp)
    (past-edge next-loc)
  ::
  ++  move-to-edge
    ::  Move the target to the edge in a direction
    ::
    |=  [dp=[@s @s] target=[@s @s]]
    ^-  [@s @s]
    ?:  (at-edge-in-dir dp target)
      target
    $(target (add-loc target dp))
  ::
  ++  inv-dp
    ::  Find the inverse of a direction
    ::
    |=  dp=[@s @s]
    ^-  [@s @s]
    [(pro:si -.dp -1) (pro:si +.dp -1)]
  :: 
  ++  line-at-target
    ::  finds a line using a direction and a point to
    ::  include that reachs from edge to edge and 
    ::  includes that point
    ::
    |=  [dp=[@s @s] target=[@s @s]]
    ^-  (list [@s @s])
    =/  line-start=[@s @s]   (move-to-edge dp target)
    =/  inv=[@s @s]          (inv-dp dp)
    =/  cur-loc=[@s @s]      (add-loc line-start inv)
    =/  path=(list [@s @s])  ~[cur-loc line-start]
    |-  ^-  (list [@s @s])
    ?:  (at-edge-in-dir dp cur-loc)  path
    =/  new-loc=[@s @s]      (add-loc cur-loc inv)
    %=  $
      cur-loc              new-loc
      path                 [new-loc path]
    ==
  ::
  ++  suple
    |=  x=[@ @]
    ^-  [@s @s]
    [(new:si & -.x) (new:si & +.x)]

  ++  unsuple
    |=  x=[@s @s]
    ^-  [@ @]
    [(abs:si -.x) (abs:si +.x)]

  ++  max-in-line-help
    ::  max in line helper function, don't use this
    ::
    |=  [for=?($a $b $empty) line=(list [@s @s])]
    ^-  s=[m=(list [@s @s]) c=(list [@s @s])]
    %+  roll  line
      |=  [here=[x=@s y=@s] s=[m=(list [@s @s]) c=(list [@s @s])]]
      =+  player-here=(~(got by b.g) here)
      ?:  =(player-here for)
        =+  c=[here c.s]
        %_  s
          m  ?:  (gth (lent m.s) (lent c))  m.s  c
          c  c  
        ==
      %_  s
        m  m.s
        c  ~
      ==
  ::
  ++  max-in-line
    ::  Find the max contiguous plays in a line
    ::  given a player `for` and a line
    ::
    |=  [for=?($a $b $empty) line=(list [@s @s])]
    ^-  (list [@s @s])
    m:s:(max-in-line-help for line)
  ::
  ++  caused-win-in-dir
    ::  Always starting from the top of the board
    ::  Search downward for a path that is of
    ::  length ts or better
    ::
    |=  [tc=@ target=[x=@s y=@s] dp=[@s @s]]
    ^-  (unit (list [@s @s]))
    =+  player-here=(~(got by b.g) target)
    =+  line=(line-at-target dp target)
    =+  max-line=(max-in-line player-here line)
    ?:  (gte tc (lent max-line)) 
      (some max-line)
    ~
  ::
  ::    Directions
  ::    [-1 1] [0 1] [1 1] 
  ::  y [-1 0]   *   [1 0]
  ::    [-1 -1][0 -1][1 -1]
  ::             x
  ::  we only need to test the upper triangle 
  ::  of this matrix of directions because the 
  ::  lower triange is the inverse of each item
  ::  in the upper diagnal
  ++  caused-win
    |=  [t=[@ @]]
    ^-  (unit (list [@ @]))
    =/  dirs=(list [@s @s])  
      ~[[-1 --0] [-1 --1] [--0 --1] [--1 --1]]
    =/  ws=(unit (list [@s @s]))
      %+  roll  dirs
        |=  [dir=[@s @s] win=(unit (list [@s @s]))]
        ^-  (unit (list [@s @s]))
        =/  nt=[@s @s]  (suple t) 
        ?~  win
          (caused-win-in-dir 4 nt dir)
        win
    %+  bind  ws
      |=  l=(list [@s @s])
      ^-  (list [@ @])
      (turn l unsuple)
     

  ++  maybe-move
    :: returns a unit game of a new-board if the move was valid
    :: and an nil if not
    ::
    |=  [movex=@]
    ^-  (unit game-state)
    ?:  ?!  (can-move movex)
      [~]
    (some (move movex))
  --
--

