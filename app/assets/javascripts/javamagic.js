var load_functions;
load_functions = function() {
  $("#search_by_name").keydown(function(event){
    if(event.keyCode == 13){
      search_by_name();        
    }
  });
  $("#search_by_card").keydown(function(event){
    if(event.keyCode == 13){
      search_by_card();        
    }
  });

  $("html").click(function(){
    $("#menu_widget").hide();
  });

  $("#menu_button_div").click(function(e){
    e.stopPropagation();
  });

};

$(document).ready(load_functions);
$(document).on('page:load', load_functions);

function toggle_menu(){
  $( "#menu_widget" ).toggle()
}


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

function award_experience(participant_id){
  var target_div = '#award_form_' + participant_id
  var experience_id = $(target_div).val();
  if (experience_id == ""){
    alert("select a reward")
    return
  }else{
    var url = '/main/award_patron.json?participant=' + participant_id + '&experience=' + experience_id
    $.get(url, function(data){
      console.log('award_sent')
    }).done(function(){
      location.reload();
    }).fail(function(){
      alert('Something is borked! Try again later.')
    });
  }
}

function register(){
  var first_name = $("#first_name").val();
  var last_name = $("#last_name").val();
  var age = $("#age").val();
  var grade = $("#grade").val();
  var school = $("#school").val();
  var zip_code = $("#zip_code").val();
  var home_library = $("#home_library").val();
  var club = $("input:radio[name=club]:checked").val();
  var email = $("#email").val();
  var library_card = $("#library_card").val();
  var message_div = "#messages"


  if (first_name.length == "0" || last_name.length == "0" || age.length == "0" || grade.length == "0" || school.length == "0" || zip_code.length == "0" || home_library.length == "0" || typeof club == "undefined") {
    alert("missing required feilds")
  }else{
    base_url = '/main/register.json'
    parameters = '?first_name='+ encodeURIComponent(first_name) + '&last_name=' + encodeURIComponent(last_name) + '&age=' + encodeURIComponent(age) + '&grade=' + encodeURIComponent(grade) + '&school=' + encodeURIComponent(school) + '&zip_code=' + encodeURIComponent(zip_code) + '&home_library=' + encodeURIComponent(home_library) + '&club=' + encodeURIComponent(club) + '&email=' + encodeURIComponent(email) + '&library_card=' + encodeURIComponent(library_card)
    full_url = base_url + parameters;
    $.get(full_url, function(data){
      console.log('registration sent');
    }).done(function() {
      $(message_div).html('<h3>Succes</h3>');   
    }).fail(function() {
      $(message_div).html('<h3>Something bad happened. Please try again later...</h3>'); 
    });
  }
}

function search_by_name(){
 var name = $('#search_by_name').val();
 var clean_name = encodeURIComponent(name);  
  if (name){
    var url = '/main/search_by_name?name=' + clean_name
    Turbolinks.visit(url)
     }else{
    alert("enter a name!");  
     }     
}

function search_by_card(){
 var card = $('#search_by_card').val();
 var clean_card = encodeURIComponent(card);  
  if (card){
    var url = '/main/search_by_card?card=' + clean_card
    Turbolinks.visit(url)
     }else{
    alert("enter a card# !");  
     }     
}











