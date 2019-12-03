|%
+$  action
  $%  $:  %new-game
          x=@
          y=@
      ==
      $:  %play-move
          s=@
      ==
  ==
+$  state       ?($a $b $empty)
+$  cord        [x=@ y=@]
+$  size        [x=@ y=@]
+$  cur-player  ?($a $b)
+$  board       (map cord state)
+$  slot-state  @
+$  slot-states  (list @)
+$  players     [a=@p b=@p]
+$  game-state 
  $:  
      =cur-player
      =players
      cords=(list cord)
      b=board
      ss=slot-states
      =size
  ==
--
