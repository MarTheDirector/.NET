<!DOCTYPE html>
<html>
<head>
<!--#include file="../includes/header.asp"-->
<title>
ASC Tutor Scheduling Website
</title>
</head>
<body>
    <!--#include file="../includes/navbar-admin.asp"-->
    <%


        findTutorStatus = getStatusOfPage("findTutor")
        tuteeUpdateInfoStatus = getStatusOfPage("updateTuteeInfo")
        tuteeViewInfoStatus = getStatusOfPage("tuteeViewInfo")
        tutorChangeAvailabilityStatus = getStatusOfPage("changeAvail")

       If Request.ServerVariables("REQUEST_METHOD")= "POST"  Then
            EstablishDBCON rsLockPages,conLockPages
        
            'Fill up each response into a var, grab from each select
            valLockTutorSelection = (Request.Form("lockTutorSelection"))
            valLockTuteeUpdateInfo = (Request.Form("lockTuteeUpdateInfoSelection"))
            valLockTuteeViewInfo = (Request.Form("lockTuteeViewInfoSelection"))
            valtutorChangeAvailability = (Request.Form("lockTutorChangeAvailability"))

            If valLockTutorSelection <> findTutorStatus then
                'update query
                sqlString = "exec dbo.LockUnlockPage @PageName ='findTutor', @Status = '"&valLockTutorSelection&"'"
                rsLockPages.Open sqlString

                'success alert up top
                 Response.write("<div class='alert alert-success'>Tutee tutor selection updated to "&valLockTutorSelection&" <br/> </div>")

            end if

            If valLockTuteeUpdateInfo <> tuteeUpdateInfoStatus then
                'update query
                sqlString = "exec dbo.LockUnlockPage @PageName ='updateTuteeInfo', @Status = '"&valLockTuteeUpdateInfo&"'"
                rsLockPages.Open sqlString

                'success alert up top
                 Response.write("<div class='alert alert-success'>Tutee update info page updated to "&valLockTuteeUpdateInfo&" <br/> </div>")
                 
            end if

             If valLockTuteeViewInfo <> tuteeViewInfoStatus then
                'update query
                sqlString = "exec dbo.LockUnlockPage @PageName ='tuteeViewInfo', @Status = '"&valLockTuteeViewInfo&"'"
                rsLockPages.Open sqlString

                'success alert up top
                 Response.write("<div class='alert alert-success'>Tutee view info page updated to "&valLockTuteeViewInfo&" <br/> </div>")
                 
            end if

              If valtutorChangeAvailability <> tutorChangeAvailabilityStatus then
                'update query
                sqlString = "exec dbo.LockUnlockPage @PageName ='changeAvail', @Status = '"&valtutorChangeAvailability &"'"
                rsLockPages.Open sqlString

                'success alert up top
                 Response.write("<div class='alert alert-success'>Tutor change availability page updated to "&valtutorChangeAvailability &" <br/> </div>")
                 
            end if

        findTutorStatus = valLockTutorSelection 
        tuteeUpdateInfoStatus = valLockTuteeUpdateInfo
        tuteeViewInfoStatus = valLockTuteeViewInfo
        tutorChangeAvailabilityStatus = valtutorChangeAvailability 

        end if  
        'end of post

    %>

    <div class="container">
    <form name="lockForm" class="form-horizontal" action="lock-page.asp"  method="POST">   

    <div class= "well">         
    <h1>Tutee Pages</h1>
        <hr style="margin: 0 0 1em 0;">
		<p class="lead">
        Find tutor page. Allows tutees to sign up for tutors. Current Status: <strong><%Response.Write(findTutorStatus)%></strong> 
            <div class="control-group">
                <div class="controls">  
                <select name="lockTutorSelection">
                    <option selected style='background-color:#ffc120;' value="<%Response.Write(findTutorStatus)%>"><%Response.Write(findTutorStatus)%></option>
                    <% 
                        if trim(findTutorStatus) = "Locked" then
                            Response.Write("<option value='Unlocked'>Unlocked</option>")
                        else 
                            Response.Write("<option value='Locked'>Locked</option>")
                        end if
                     %>
                 </select>
                </div>
            </div>
            </p>
          <p class="lead">
          Update tutee info page. Allows tutees to update info. <strong><%Response.Write(tuteeUpdateInfoStatus)%></strong>
            <div class="control-group">
              <div class="controls">  
                <select name="lockTuteeUpdateInfoSelection">
                    <option selected style='background-color:#ffc120;' value="<%Response.Write(tuteeUpdateInfoStatus)%>"><%Response.Write(tuteeUpdateInfoStatus)%></option>
                    <% 
                        if trim(tuteeUpdateInfoStatus) = "Locked" then
                            Response.Write("<option value='Unlocked'>Unlocked</option>")
                        else 
                            Response.Write("<option value='Locked'>Locked</option>")
                        end if
                     %>
                 </select>
               </div>
            </div>
            </p>
            <p class="lead">
        Page that allows tutees to view info. Current Status: <strong><%Response.Write(tuteeViewInfoStatus)%></strong> 
            <div class="control-group">
                <div class="controls">  
                <select name="lockTuteeViewInfoSelection">
                    <option selected style='background-color:#ffc120;' value="<%Response.Write(tuteeViewInfoStatus)%>"><%Response.Write(tuteeViewInfoStatus)%></option>
                    <% 
                        if trim(tuteeViewInfoStatus) = "Locked" then
                            Response.Write("<option value='Unlocked'>Unlocked</option>")
                        else 
                            Response.Write("<option value='Locked'>Locked</option>")
                        end if
                     %>
                 </select>
                </div>
            </div>
            </p>
         </div>
       


    
    <div class= "well">         
    <h1>Tutor Pages</h1>
        <hr style="margin: 0 0 1em 0;">
		<p class="lead">
        Page that allows tutors to sign change their availablity. Current Status: <strong><%Response.Write(tutorChangeAvailabilityStatus)%></strong> 
            <div class="control-group">
                <div class="controls">  
                <select name="lockTutorChangeAvailability">
                    <option selected style='background-color:#ffc120;' value="<%Response.Write(tutorChangeAvailabilityStatus)%>"><%Response.Write(tutorChangeAvailabilityStatus)%></option>
                    <% 
                        if trim(tutorChangeAvailabilityStatus) = "Locked" then
                            Response.Write("<option value='Unlocked'>Unlocked</option>")
                        else 
                            Response.Write("<option value='Locked'>Locked</option>")
                        end if
                     %>
                 </select>
                </div>
            </div>
            </p>
         </div>
        </div>


        <div class="form-actions">
            <a href="lock-page.asp"><button class="btn btn-primary">Submit Changes</button></a>
            <a href="default.asp" class="btn btn-inverse">Back</a>
        </div>
    </form>
<hr>    
  <footer>
     <!--#include file="../includes/footer.asp"-->
  </footer>

    </div> <!-- /container -->
</body>
</html>