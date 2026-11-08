program fatorial;
var
  n, i, f : integer;
begin
  write('n = ');
  readln(n);
  f := 1;
  i := 2;
  while i <= n do
  begin
    f := f * i;
    i := i + 1
  end;
  writeln('fatorial = ', f)
end.