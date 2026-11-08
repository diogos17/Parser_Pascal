PROGRAM Media;
VAR
  x, y, z : Real;   
  total   : Integer;
Begin
  READ(x, y, z);
  { media aritmetica }
  x := (x + y + z) / 3.0;
  total := 3 * 2 DIV 4 MOD 5;
  WriteLn('media: ', x, ' total: ', total)
End.
 