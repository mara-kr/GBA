-- *********************************************************************************************				   
-- Package for S19 file reader 
-- Modified 07.02.2003 
-- Designed by Ruslan Lepetenok 
-- *********************************************************************************************				   
 
package S19FRPackage is 
function LOG2(Number : positive) return natural; 
function CharToNatural(InChar : character) return natural; 
end S19FRPackage; 
 
package body S19FRPackage is 
 
function LOG2(Number : positive) return natural is 
variable Temp : positive := 1; 
begin 
if Number=1 then  
 return 0; 
  else  
   for i in 1 to integer'high loop 
    Temp := 2*Temp;  
     if Temp>=Number then  
      return i; 
     end if; 
end loop;
return 0; 
end if;	 
end LOG2;	 
 
-- Converts symbols 0..9,A..F(a..f) to  
function CharToNatural(InChar : character) return natural is  
variable ArgTmpInt : natural := 0; 
begin 
if InChar>='0' and InChar<='9' then 
 ArgTmpInt := character'pos(InChar)-character'pos('0'); 
  elsif InChar>='A' and InChar<='F' then 
   ArgTmpInt := character'pos(InChar)-character'pos('A')+10; 
   elsif InChar>='a' and InChar<='f' then	 
    ArgTmpInt := character'pos(InChar)-character'pos('a')+10; 
    else report"Error in hexadecimal" severity FAILURE;	    
	end if;	 
return ArgTmpInt; 
end CharToNatural; 
 
end S19FRPackage; 

