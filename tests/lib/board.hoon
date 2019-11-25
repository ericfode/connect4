/-  board
/+  *board,*test
::
::  Testing arms

=+  gm=play
=+  brd=g:gm
=+  a-cords=(new-cords 1 1)
=+  a-map=(new-board a-cords)
=+  expt-cord=~[[x=0 y=0] [x=0 y=1] [x=1 y=0] [x=1 y=1]]
=+  a-slot-state=(new-slot-state 1 1)
=/  exp-map  %:  my 
      :~  [[x=0 y=0] %empty] 
          [[x=0 y=1] %empty]
          [[x=1 y=0] %empty]
          [[x=1 y=1] %empty]
      ==
    ==
=/  our-game=game-state  (new-game:gm 2 2)
=+  empty-game=our-game
=/  exp-game=game-state  
  %_  empty-game
    cords           a-cords
    b               a-map
    ss              a-slot-state
    cur-player      %a
    players         [a=~nec b=~bud]
  ==

|%
++  test-cords-gen
  %+  expect-eq
    !>  expt-cord
    !>  a-cords
++  test-map-gen
  ;:  weld
    %+  expect-eq
      !>  exp-map
      !>  a-map
    %+  expect-eq
      !>  empty-game
      !>  exp-game
  ==

++  test-state-gen
  ;:  weld
    %+  expect-eq
       !>  2
       !>  (lent ss.our-game)
    %+  expect-eq
       !>  [x=2 y=2]
       !>  size.our-game
  ==
++  test-move-rules
  ;:  weld
    %+  expect-eq
      !>  %.n
      !>  (~(can-move play our-game) 10)
    %+  expect-eq
      !>  %.n
      !>  (~(can-move play our-game) 2)
    %+  expect-eq
      !>  %.y
      !>  (~(can-move play our-game) 1)
  ==
++  test-move
  ;:  weld
    %+  expect-eq
      !>  %_  exp-game
            ss          ~[1 2]
            cur-player  %b
            b  %:  my 
                 :~  [[x=0 y=1] %empty]
                   [[x=0 y=0] %a] 
                   [[x=1 y=1] %empty]
                   [[x=1 y=0] %empty]
                 ==
          ==
        ==
      !>  (~(move play our-game) 0)
    %+  expect-eq
      !>  %_  exp-game
            ss          ~[2 1]
            cur-player  %b
            b  %:  my 
                 :~  [[x=0 y=1] %empty]
                   [[x=0 y=0] %empty] 
                   [[x=1 y=1] %empty]
                   [[x=1 y=0] %a]
                 ==
          ==
        ==
      !>  (~(move play our-game) 1)
    %+  expect-eq
      !>  %_  exp-game
            ss          ~[2 1]
            cur-player  %b
            b  %:  my 
                 :~  [[x=0 y=1] %empty]
                   [[x=0 y=0] %empty] 
                   [[x=1 y=1] %empty]
                   [[x=1 y=0] %a]
                 ==
          ==
        ==
      !>  (~(move play our-game) 1)
    %+  expect-eq
      !>  %_  exp-game
            ss          ~[2 0]
            cur-player  %a
            b  %:  my 
                 :~  [[x=0 y=1] %empty]
                   [[x=0 y=0] %empty] 
                   [[x=1 y=1] %b]
                   [[x=1 y=0] %a]
                 ==
          ==
        ==
      !>  =+  b0=(~(move play exp-game) 1)
          =+  b1=(~(move play b0) 1)
          b1
    %+  expect-eq
      !>  ~ 
      !>  =+  b0=(~(move play exp-game) 1)
          =+  b1=(~(move play b0) 1)
          (~(maybe-move play b1) 1)
  ==
++  test-add-loc
  %+  expect-eq
    !>  [--1 --2]
    !>  (~(add-loc play exp-game) [--0 --1] [--1 --1])
++  test-inv-dp
  %+  expect-eq
    !>  [--0 -1]
    !>  (~(inv-dp play exp-game) [--0 --1])
++  test-past-edge
  ;:  weld
    %+  expect-eq
      !>  %.y
      !>  (~(past-edge play exp-game) [--8 --1]) 
    %+  expect-eq
      !>  %.n
      !>  (~(past-edge play exp-game) [--1 --1]) 
    %+  expect-eq
      !>  %.y
      !>  (~(past-edge play exp-game) [-1 --1]) 
  ==
::
++  test-line-at-target
  ;:  weld
    %+  expect-eq
      !>  `(list [@s @s])`~[[--0 --0] [--0 --1]]
      !>  (~(line-at-target play exp-game) [--0 --1] [--0 --0])
    %+  expect-eq
      !>  `(list [@s @s])`~[[--0 --0] [--0 --1] [--0 --2]]
      !>  =+  b=(new-game:gm 3 3)
          (~(line-at-target play b) [--0 --1] [--0 --0])
    %+  expect-eq
      !>  `(list [@s @s])`~[[--0 --0] [--1 --1] [--2 --2]]
      !>  =+  b=(new-game:gm 3 3)
          (~(line-at-target play b) [--1 --1] [--0 --0])
    %+  expect-eq
      !>  `(list [@s @s])`~[[--0 --0] [--1 --1] [--2 --2]]
      !>  =+  b=(new-game:gm 3 3)
          (~(line-at-target play b) [--1 --1] [--1 --1])
    %+  expect-eq
      !>  `(list [@s @s])`~[[--0 --1] [--1 --1] [--2 --1]]
      !>  =+  b=(new-game:gm 3 3)
          (~(line-at-target play b) [--1 --1] [--1 --0])
  %+  expect-eq
      !>  `(list [@s @s])`~[[--0 --1] [--1 --1] [--2 --1]]
      !>  =+  b=(new-game:gm 3 3)
          (~(line-at-target play b) [--2 --1] [--1 --0])
  ==
::
++  test-suple-and-unsuple
  ;:  weld
    %+  expect-eq
      !>  [1 1]
      !>  (unsuple:play (suple:play [1 1]))
    %+  expect-eq
      !>  [0 1]
      !>  (unsuple:play (suple:play [0 1]))
  ==
::
++  test-max-in-line
  ;:  weld
    %+  expect-eq
      !>  `(list [@s @s])`~[[--0 --1] [--1 --1] [--2 --1]]
      !>  =+  b=(new-game:gm 4 4)
          =.  b  (~(move play b) 3)
          =.  b  (~(move play b) 2)
          =.  b  (~(move play b) 3)
          =.  b  (~(move play b) 2)
          =.  b  (~(move play b) 3)
          =+  l=(~(line-at-target play b) [--2 --1] [--0 --1])
          (~(max-in-line play b) %a l)
    %+  expect-eq
      !>  `(list [@s @s])`~[[--2 --1] [--3 --1]]
      !>  =+  b=(new-game:gm 4 4)
          =.  b  (~(move play b) 3)
          =.  b  (~(move play b) 3)
          =.  b  (~(move play b) 3)
          =.  b  (~(move play b) 2)
          =.  b  (~(move play b) 3)
          =.  b  (~(move play b) 2)
          =.  b  (~(move play b) 3)
          =+  l=(~(line-at-target play b) [--2 --1] [--0 --1])
          (~(max-in-line play b) %a l)
  ==
::
++  test-caused-win-in-dir
  ;:  weld
    %+  expect-eq
      !>  `(list [@s @s])`~[[--0 --1] [--1 --1] [--2 --1]]
      !>  =+  b=(new-game:gm 4 4)
          =.  b  (~(move play b) 3)
          =.  b  (~(move play b) 2)
          =.  b  (~(move play b) 3)
          =.  b  (~(move play b) 2)
          =.  b  (~(move play b) 3)
          (~(caused-win-in-dir play b) 3 [--2 --1] [--0 --1])
    %+  expect-eq
      !>  (some `(list [@s @s])`~[[--1 --1] [--2 --1] [--3 --1]])
      !>  =+  b=(new-game:gm 4 4)
          =.  b  (~(move play b) 2)
          =.  b  (~(move play b) 3)
          =.  b  (~(move play b) 3)
          =.  b  (~(move play b) 2)
          =.  b  (~(move play b) 3)
          =.  b  (~(move play b) 2)
          =.  b  (~(move play b) 3)
          =.  b  (~(move play b) 2)
          =.  b  (~(move play b) 3)
          (~(caused-win-in-dir play b) 3 [--3 --1] [--0 --1])
  ==
::
++  test-caused-win
  ;:  weld
    %+  expect-eq
      !>  `(list [@s @s])`~[[--0 --1] [--1 --1] [--2 --1]]
      !>  =+  b=(new-game:gm 4 4)
          =.  b  (~(move play b) 3)
          =.  b  (~(move play b) 2)
          =.  b  (~(move play b) 3)
          =.  b  (~(move play b) 2)
          =.  b  (~(move play b) 3)
          (~(caused-win play b) [2 1])
    %+  expect-eq
      !>  (some `(list [@s @s])`~[[--1 --1] [--2 --1] [--3 --1]])
      !>  =+  b=(new-game:gm 4 4)
          =.  b  (~(move play b) 2)
          =.  b  (~(move play b) 3)
          =.  b  (~(move play b) 3)
          =.  b  (~(move play b) 2)
          =.  b  (~(move play b) 3)
          =.  b  (~(move play b) 2)
          =.  b  (~(move play b) 3)
          =.  b  (~(move play b) 2)
          =.  b  (~(move play b) 3)
          (~(caused-win play b) [3 1])
  ==
--
