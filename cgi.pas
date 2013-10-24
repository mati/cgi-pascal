Unit cgi;
interface
	uses dos;
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
	procedure init;
	function getValue(List:TList; name:string):string;
	function get(name:string):string;
	function post(name:string):string;

implementation
	var query_string:string;
	
	procedure init;
		var
			newTList:TList;
			head:TList;
			tail:TList;
			i:integer;
			s:string;
			c:char;
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
					else
						begin
							newTList:=new(TList);
							head:=newTList;
							tail:=newTList;
						end;
					s:='';
					while (query_string[i]<>'=') and (i<=length(query_string)) do
						begin
							s:=s+query_string[i];
							inc(i);
						end;
					newTList^.Name:=s;
					inc(i);
					s:='';
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
	begin
		s:=getenv('QUERY_STRING');
		if s <> '' then ListHeadGET:=parse_query(s);
		s:='';
		while not EOF(input) do
			begin
				read(c);
				s:=s+c;
			end;
		if s <> '' then ListHeadPOST:=parse_query(s);
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
end.
