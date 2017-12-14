<%
function RemoveInject (string stuff)

Replace(username,";","",1,-1,1)
Replace(username,"'","",1,-1,1)
Replace(username,"--","",1,-1,1)
Replace(username,"/*","",1,-1,1)
Replace(username,"*/","",1,-1,1)
Replace(username,"xp_","",1,-1,1)

returns stuff

end function
%>





<%
query user time info

A function takes the start and stop time and splits it into 15 or 30 min intervals.
put in an arrray/list

Same function or another 
queries unavailable times that are in use for some reason.

function splits these unavail times into 15 or 30 min intervals
put in array/list

Now compare 
check for dupes
remove dupes

checkboxes

These intervals are displayed as available times to tutor.

