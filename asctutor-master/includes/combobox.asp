  <link rel="stylesheet" href="//code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css">
  <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"> </script>
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
                                     input.data( "ui-autocomplete" ).term = "";
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
 
    

  </script>