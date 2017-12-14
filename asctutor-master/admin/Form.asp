<!-- 
   Name:  Tutor Schedule Update Forms
   Written By:  Ethan Hanner, Marcus Nesbitt, Courtney Stokes, Tara Slabich
   System:  Part of the Tutor Schedule Update component of the ASC Tutor Schedule Portal 
   Created: Spring 2015
   Purpose: Provides user with an interface to create a back-up of the current Courses table in the asc_tutor database.  
            Then allows user to verify the copy of the back-up.  Then provides user with an option to select a file to 
            upload into the Coureses table.  
   How:  The HTML script displays the page in ASC Tutor Schedule Portal website.  The jQuery switches between the different sections
         of the HTML script to present the interface in three separate sections to the user.      
   
-->



<!-- disable session state for this page. if session state is enabled, then data
    will not be processed until the file has been received -->
<%@EnableSessionState=False %>


<!DOCTYPE html>
<html>
    <head>
        <!--#include file="../includes/header.asp"-->
        <title> ASC: File Upload</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
        <script type="text/javascript">
           $(document).ready(
                function () {
                    $("#verifyDiv, #selectDiv").hide();
                    $("#backup").on('click', function () {
                        $("#backupDiv").hide();
                        $("#verifyDiv").show();
                    });
                    $("#retry").on('click', function () {
                        $("#verifyDiv").hide();
                        $("#backupDiv").show();                        
                    });
                    $("#copySuccess").on('click', function () {
                        $("#verifyDiv").hide();
                        $("#selectDiv").show();
                    });
                });

                          
        </script>
    </head>
    <body>
        <!--#include file="../includes/navbar-admin.asp"-->
        <div class="container">            
            <div class="lead">
                <!-- Creates a copy of the Course table to a .csv file in the downloads or deafult folder. -->
                <div id="backupDiv">
                    <h2>Backup</h2>
                    <p>Back up the Course table before uploading the new information.</p>
                    <a href="../admin/export-course-table.asp" class="btn btn-success" id="backup">Backup Courses Table</a>
                </div>
                <br />
                <!-- Ask user to verify copy of Course table is saved to .csv file in downloads or default folder -->
                <div id="verifyDiv">
                    <h2>Verify Copy</h2>
		            <div id="checkIns" class="lead">
                        <p>
                            Please verify that a copy of the previous semesters course information has saved before proceeding:
                        </p>
                        <ol>
                            <li>Open the folder entitled "downloads" from the local directory.</li>
                            <li>Open the file entitled "courses.csv".</li>
                            <li>Determine if the correct information is contained in the file.</li>
                            <li>Make the appropriate selection below.
                                    <ol>
                                        <li>Select Procced to continue.</li>
                                        <li>Select Retry to attempt another copy.</li>
                                        <li>Select Cancel if a copy is not succesfully made or if you want to end the process for any reason.  Contact the system administrator before proceeding if the copy is not successfully made.</li>
                                    </ol>
                            </li>
                              
                        </ol>
                    </div>
                    <div id="copyBtns">
        	            <a href="#" class="btn btn-success" id="copySuccess">Proceed</a>
                        <a href="#" class="btn btn-inverse" id="retry">Retry</a>
                        <a href="default.asp" class="btn btn-primary">Cancel</a>
		            </div>
                </div>   
                <!-- Asks user to select .csv file with new Course table information to upload to database -->
                <div id="selectDiv">
                <h2>Select File</h2>
                <p>Choose the .csv file containing the updated list of course information.</p>
                <form method="post" enctype="multipart/form-data" action="Upload.asp" name="UploadForm">
                   
                        <input type="file" name="File1" />
                  
                    <input class="btn btn-success" type="submit" value="Upload" />
                </form>
                </div>
            </div>
            <hr />
            <footer>
                <!--#include file="../includes/footer.asp"-->
            </footer>
        </div> <!-- /container -->
    </body>
</html>