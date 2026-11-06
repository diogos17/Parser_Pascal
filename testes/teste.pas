program teste;
var
  a, b, soma : integer;
  r : real;
  nome : string;
  ok : boolean;
begin
  write('nome: ');
  readln(nome);
  read(a, b);

  soma := a + b * 2;
  r := (a + b) / 2.5;
  a := -a + 10 div 3;
  b := b mod 4;
  nome := 'ola ' + nome;
  ok := a < b;

  if a > b then
    writeln('a maior')
  else
  begin
    writeln('b maior ou igual');
    b := b - 1
  end;

  if not (a = b) and (soma >= 0) or false then
    writeln('condicao verdadeira');

  while a < 10 do
  begin
    a := a + 1;
    if a mod 2 = 0 then
      write(a, ' ')
  end;

  writeln;
  writeln(nome, ' soma = ', soma, ' ok = ', ok)
end.
