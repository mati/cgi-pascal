Unit CGI;
interface
uses Dos;
type
	TList = ^TData_Pair;
	TData_Pair = record
		Name:string;
		Value:string;
		Next:TList;
	end;
var
	ListHeadGET:TList;
	ListHeadPOST:TList;
    ListHeadCookie:TList;

procedure initCGI;
function getValue(List:TList; name:string):string;
function get(name:string):string;
function post(name:string):string;
procedure setCookie(name:string;value:string);
procedure setCookie(name:string;value:string;time:string);
function getCookie(name:string):string;

implementation
procedure initCGI;
var     newTList:TList;
	head:TList;
	tail:TList;
	i:integer;
	s:string;
	c:char;
        l:integer;
function parse_query(query_string:string):TList;
	begin
	i:=1;
	head:=nil;
	tail:=nil;
	while i<=length(query_string) do
	begin
		if head<>nil then
		begin
                        tail:=new(TList);
			newTList^.next:=tail;
			newTList:=tail;
		end
		else {if list does not exist}
		begin
                        newTList:=new(TList);
			head:=newTList;
			tail:=newTList;
		end;
		s:='';{get name of variable}
		while (query_string[i]<>'=') and (i<=length(query_string)) do
		begin
			s:=s+query_string[i];
			inc(i);
		end;
		newTList^.Name:=s;
		inc(i);
		s:='';{get value of variable}
		while (query_string[i]<>'&') and (i<=length(query_string)) do
		begin
                        s:=s+query_string[i];
			inc(i);
		end;
			newTList^.Value:=s;
			inc(i);
			s:='';
		end;
		parse_query:=head;
end;
function parse_cookie(query_string:string):TList;
	begin
	i:=1;
	head:=nil;
	tail:=nil;
	while i<=length(query_string) do
	begin
		if head<>nil then
		begin
                        tail:=new(TList);
			newTList^.next:=tail;
			newTList:=tail;
		end
		else {if list does not exist}
		begin
                        newTList:=new(TList);
			head:=newTList;
			tail:=newTList;
		end;
		s:='';{get name of variable}
		while (query_string[i]<>'=') and (i<=length(query_string)) do
		begin
			s:=s+query_string[i];
			inc(i);
		end;
		newTList^.Name:=s;
		inc(i);
		s:='';{get value of variable}
		while (query_string[i]<>';') and (i<=length(query_string)) do
		begin
                        s:=s+query_string[i];
			inc(i);
		end;
			newTList^.Value:=s;
			inc(i);
                        inc(i);
			s:='';
		end;
		parse_cookie:=head;
end;

begin
        {parse string if method GET}
	s:=getenv('QUERY_STRING');
	if s <> '' then ListHeadGET:=parse_query(s);
	s:='';
        {parse string if method POST}
        val(getenv('CONTENT_LENGTH'),l);
	while (not EOF(input)) and (length(s)<l) do
	begin
                read(c);
		s:=s+c;
	end;
	if s <> '' then ListHeadPOST:=parse_query(s);
        {parse cookie string if exist}
        s:=getenv('HTTP_COOKIE');
        if s <> '' then ListHeadCookie:=parse_cookie(s);
end;

function getValue(List:TList; name:string):string;
var
	newTList:TList;
begin
	newTList:=List;
	while (newTList<>nil) and (newTList^.Name<>name) do
        begin
            newTList:=newTList^.next;
        end;
	if newTList<>nil then getValue:=newTList^.Value
	else getValue:='';
end;

function get(name:string):string;
begin
	get:=getValue(ListHeadGET, name);
end;

function post(name:string):string;
begin
	post:=getValue(ListHeadPOST, name);
end;

procedure setCookie(name:string;value:string);
begin
    writeln('Set-Cookie:  '+name+'='+value+'; path=/;');
end;

procedure setCookie(name:string;value:string;time:string);
begin
    writeln('Set-Cookie:  '+name+'='+value+'; expires='+time+'; path=/;');
end;

function getCookie(name:string):string;
begin
    getCookie:=getValue(ListHeadCookie, name);
end;

end.
