program lab3;
 uses crt, CGI;
 var a,b,c:integer;
    d,x,y:real;
    s:string;
    bool:boolean;
begin
 initCGI;
 bool:=false;
 s:=post('a');
 val(s,a);
 bool:=(s='');
 setCookie('a',s);
 s:=post('b');
 val(s,b);
 if (bool)then bool:=(s='');
 setCookie('b',s);
 s:=post('c');
 val(s,c);
 if (bool)then bool:=(s='');
 setCookie('c',s);
 if (bool) then
 begin
  val(getCookie('a'),a);
  val(getCookie('b'),b);
  val(getCookie('c'),c);
 end;
 writeln('Content-Type: text-html; charset=utf-8');
 writeln;
 writeln('<!DOCTYPE html>');
 writeln('<html>');
 writeln('<head>');
 writeln('<meta charset=utf-8>');
 writeln('</head>');
 writeln('<body>');
 writeln('<form action="lab3.cgi" method="POST">');
 writeln('<p><input name="a" type="text" value="',a,'">x^2 +');
 writeln('<input name="b" type="text" value="',b,'">x +');
 writeln('<input name="c" type="text" value="',c,'"> = 0</p>');
 writeln('<p><input type="submit"> </p>');
 writeln('</form>');
 if (not bool) then
 begin
        if a<>0 then
        begin
                d:=b*b-4*a*c;
                if d<0 then writeln('net kornei')
                else if d=0 then
                begin
                    x:=(-b)/(2*a);
                    writeln('x=',x:4:2);
                end
                else
                begin
					x:=(-b+sqrt(d))/(2*a);
					y:=(-b-sqrt(d))/(2*a);
					writeln('x1=',x:4:2);
					writeln('<br>');
					writeln('x2=',y:4:2);
                end;
        end
        else
        begin
                x:=(-c)/b;
                writeln('x=',x:4:2);
        end;

 end;
end.
