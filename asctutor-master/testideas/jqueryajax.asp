<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
   
    <title></title>
</head>
<body>


    <div class="ui-widget">
        <label></label>
<select  id='combobox' >
    <option value=""> select one...</option>
	<option value='donotdeletemetutor'>donotdeletemetutor</option>
	<option value='allenc16'>allenc16</option>
</select>
        </div>
    <div id="results"> change me</div>

</body>


      $(function() {
                 $( "#combobox" ).combobox({ change: function() { alert("changed"); }});
                 $( "#toggle" ).click(function() {
                     $( "#combobox" ).toggle();
                 });

             });
    <!--#include file="../includes/combobox.asp"-->
    <script>
               $("#combobox").combobox({ 
    select: function (event, ui) { 
        alert(this.value);
    } 
});

       
         $("#combobox").change(function()
        {
            
            var id=$(this).find('option:selected').val();     
            var dataString = 'q='+ id;

            $.ajax
            ({
                    type: "GET",
                    url: "ajax-add-course-for-tutor.asp",
                   data: dataString,
                    cache: false,
                success: function(html)
                {
                    $("#results").html(html);
                } 
            });

        });
       

     

    </script>
             $("#combobox").change(function()
        {
            
            var id=$(this).find('option:selected').val();
            
            var dataString = 'q='+ id;
            //var me=  $( "#testing" ).val();    

            $.ajax
            ({
                    type: "GET",
                    url: "ajax-add-course-for-tutor.asp",
                   data: dataString,
                   // data: {q: me },
                     //data: {q:$( "#combobox" ).val()},
                    cache: false,
                success: function(html)
                {
                    $("#results").html(html);
                } 
            });

        });  
      



</html>
