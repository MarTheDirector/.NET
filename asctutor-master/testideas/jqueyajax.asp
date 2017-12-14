

<select name='testing' id='testing' >
	<option value='donotdeletemetutor'> donotdeletemetutor </option>
	<option value='allenc16'> allenc16</option>
</select>

<div id='results'> hello </div>


<script src="../js/jquery-1.8.3.min.js" > </script>

<script>
$('select[name=testing]').change(function() {
  alert( this.value ); 
});


</script>

$( "testing" ).on("change",function()
	{
		$.ajax({
				  type: "GET",
				  url: "ajax-add-course-for-tutor.asp",
				  data: { q: $( "#testing" ).val() }
			   })
		  .done(function( msg ) {
			$('#results').html( "Data Saved: " + msg );
		  });
		});
	$('#testing').on('change', function() {
	  alert( this.value ); 
	});