<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>jQuery UI Autocomplete - Combobox</title>
  <link rel="stylesheet" href="//code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css">
  <script src="//code.jquery.com/jquery-1.10.2.js"></script>
  <script src="//code.jquery.com/ui/1.11.1/jquery-ui.js"></script>
 
  <style>
  .custom-combobox {
    position: relative;
    display: inline-block;
  }
  .custom-combobox-toggle {
    position: absolute;
    top: 0;
    bottom: 0;
    margin-left: -1px;
    padding: 0;
  }
  .custom-combobox-input {
    margin: 0;
    padding: 5px 10px;
  }

      .ui-button { margin-left: -1px; }
     .ui-button-icon-only .ui-button-text { padding: 0.35em; } 
     .ui-autocomplete-input { margin: 0; padding: 0.48em 0 0.47em 0.45em; }
  </style>
  <script>
      (function( $ ) {
         $.widget( "ui.combobox", {
             _create: function() {
                 var self = this,
                     select = this.element.hide(),
                     selected = select.children( ":selected" ),
                     value = selected.val() ? selected.text() : "";
                 var input = this.input = $( "<input>" )
                     .insertAfter( select )
                     .val( value )
                     .autocomplete({
                         delay: 0,
                         minLength: 0,
                         source: function( request, response ) {
                             var matcher = new RegExp( $.ui.autocomplete.escapeRegex(request.term), "i" );
                             response( select.children( "option" ).map(function() {
                                 var text = $( this ).text();
                                 if ( this.value && ( !request.term || matcher.test(text) ) )
                                     return {
                                         label: text.replace(
                                             new RegExp(
                                                 "(?![^&;]+;)(?!<[^<>]*)(" +
                                                 $.ui.autocomplete.escapeRegex(request.term) +
                                                 ")(?![^<>]*>)(?![^&;]+;)", "gi"
                                             ), "<strong>$1</strong>" ),
                                         value: text,
                                         option: this
                                     };
                             }) );
                         },
                         select: function( event, ui ) {
                             ui.item.option.selected = true;
                             self._trigger( "selected", event, {
                                 item: ui.item.option
                             });
                             select.trigger("change");                             
                         },
                         change: function( event, ui ) {
                             if ( !ui.item ) {
                                 var matcher = new RegExp( "^" + $.ui.autocomplete.escapeRegex( $(this).val() ) + "$", "i" ),
                                     valid = false;
                                 select.children( "option" ).each(function() {
                                     if ( $( this ).text().match( matcher ) ) {
                                         this.selected = valid = true;
                                         return false;
                                     }
                                 });
                                 if ( !valid ) {
                                     // remove invalid value, as it didn't match anything
                                     $( this ).val( "" );
                                     select.val( "" );
                                     input.data( "autocomplete" ).term = "";
                                     return false;
                                 }
                             }
                         }
                     })
                     .addClass( "ui-widget ui-widget-content ui-corner-left" );
 
                 input.data( "ui-autocomplete" )._renderItem = function( ul, item ) {
                     return $( "<li></li>" )
                         .data( "item.autocomplete", item )
                         .append( "<a>" + item.label + "</a>" )
                         .appendTo( ul );
                 };
 
                 this.button = $( "<button type='button'>&nbsp;</button>" )
                     .attr( "tabIndex", -1 )
                     .attr( "title", "Show All Items" )
                     .insertAfter( input )
                     .button({
                         icons: {
                             primary: "ui-icon-triangle-1-s"
                         },
                         text: false
                     })
                     .removeClass( "ui-corner-all" )
                     .addClass( "ui-corner-right ui-button-icon" )
                     .click(function() {
                         // close if already visible
                         if ( input.autocomplete( "widget" ).is( ":visible" ) ) {
                             input.autocomplete( "close" );
                             return;
                         }
 
                         // pass empty string as value to search for, displaying all results
                         input.autocomplete( "search", "" );
                         input.focus();
                     });
             },
 
             destroy: function() {
                 this.input.remove();
                 this.button.remove();
                 this.element.show();
                 $.Widget.prototype.destroy.call( this );
             }
         });
     })( jQuery );
 
     $(function() {
         $( "#combobox" ).combobox({ change: function() { alert("changed"); }});
         $( "#toggle" ).click(function() {
             $( "#combobox" ).toggle();
         });
         $("#combobox").change(function() {
             alert(this.value);
         });
     });
  </script>
</head>
<body>
 
<div class="ui-widget">
  <label>Your preferred programming language: </label>
  <select id="combobox">
    <option value="">Select one...</option>
    <option value="ActionScript">ActionScript</option>
    <option value="AppleScript">AppleScript</option>
    <option value="Asp">Asp</option>
    <option value="BASIC">BASIC</option>
    <option value="C">C</option>
    <option value="C++">C++</option>
    <option value="Clojure">Clojure</option>
    <option value="COBOL">COBOL</option>
    <option value="ColdFusion">ColdFusion</option>
    <option value="Erlang">Erlang</option>
    <option value="Fortran">Fortran</option>
    <option value="Groovy">Groovy</option>
    <option value="Haskell">Haskell</option>
    <option value="Java">Java</option>
    <option value="JavaScript">JavaScript</option>
    <option value="Lisp">Lisp</option>
    <option value="Perl">Perl</option>
    <option value="PHP">PHP</option>
    <option value="Python">Python</option>
    <option value="Ruby">Ruby</option>
    <option value="Scala">Scala</option>
    <option value="Scheme">Scheme</option>
  </select>
</div>
<button id="toggle">Show underlying select</button>
 
 
</body>
</html>