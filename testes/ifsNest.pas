program ifs;
var
  a, b, c : integer;
begin
  read(a, b, c);
 
  if a > b then
    if b > c then
      writeln('a > b > c')
    else
      writeln('a > b mas b <= c');
 
  if a = b then
  begin
    if b = c then
      writeln('todos iguais')
  end
  else
    writeln('a diferente de b');
 
  while a > 0 do
    if a mod 2 = 0 then
      a := a div 2
    else
      a := a - 1
end.