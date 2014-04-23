function change_role(role, id){
  if (role == "approved"){
    var appended_div = "#approved_users"
  }else if(role == "unapproved"){
    var appended_div = "#unapproved_users"
  } 
  var url = '/main/change_admin_role.json?role='+ role +'&id='+ id
  var user_div = '#user_' + id
  $.ajax({
    type: "GET",
    url: url,
    success: function(data){
      if (data['message'] == 'done'){
        $(user_div).appendTo(appended_div);
      }else{
        $(user_div).append("error");
      }
    }
  }); 
}

function register(){
  var first_name = encodeURIComponent($("#first_name").val());
  var last_name = encodeURIComponent($("#last_name").val());
  var age = encodeURIComponent($("#age").val());
  var grade = encodeURIComponent($("#grade").val());
  var school = encodeURIComponent($("#school").val());
  var zip_code = encodeURIComponent($("#zip_code").val());
  var home_library = encodeURIComponent($("#home_library").val());
  var club = encodeURIComponent($("input:radio[name=club]:checked").val());
  var email = encodeURIComponent($("#email").val());
  var library_card = $("#library_card").val();
  var message_div = "#messages"

  if (typeof first_name === "undefined" || typeof last_name === "undefined" || typeof age === "undefined" || typeof grade === "undefined" || typeof school === "undefined" || typeof zip_code === "undefined" || typeof home_library === "undefined" || typeof club === "undefined") {
    alert("missing required feilds")
    return
  }
  // We should do some validation here before passing on information via ajax.
  // Things like checking zip length, verifying email address patter, etc.

  base_url = '/main/register.json'
  parameters = '?first_name='+ first_name + '&last_name=' + last_name + '&age=' + age + '&grade=' + grade + '&school=' + school + '&zip_code=' + zip_code + '&home_library=' + home_library + '&club=' + club + '&email=' + email + '&library_card=' + library_card
  full_url = base_url + parameters;
  alert(full_url)
  $.get(full_url, function(data){
      console.log('registration sent');
    }).done(function() {
        $(message_div).html('<h3>Succes</h3>');   
    }).fail(function() {
        $(message_div).html('<h3>Something bad happened. Please try again later...</h3>'); 
    });
}




