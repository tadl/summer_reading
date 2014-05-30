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

  $('.got_kit').change(function() {
     if($(this).is(":checked")) {
        var participant_id = $(this).val();
        $(this).attr('disabled', 'disabled');  
        var got_kit = 'true'
        base_url = '/main/mark_got_kit.json'
        parameters = '?participant='+ participant_id + '&got_kit=' + got_kit
        full_url = base_url + parameters;
        $.get(full_url, function(data){
        }).done(function() {
          Turbolinks.visit(document.URl) 
        }).fail(function() {
          alert('Something bad happened. Please try again later...'); 
        });
      }
  });

  $('.edit_got_kit').change(function() {
     var participant_id = $(this).val(); 
     if($(this).is(":checked")) { 
        var got_kit = 'true'
      }else{  
        var got_kit = 'false'
      }
      base_url = '/main/mark_got_kit.json'
      parameters = '?participant='+ participant_id + '&got_kit=' + got_kit
      full_url = base_url + parameters;
      $.get(full_url, function(data){
        }).done(function() {
        }).fail(function() {
          alert('Something bad happened. Please try again later...'); 
      });
  });

  $('.got_prize').change(function() {
    if($(this).is(":checked")) {
      var participant_id = $(this).val();
      $(this).attr('disabled', 'disabled');  
      var got_prize = 'true'
      base_url = '/main/mark_got_prize.json'
      parameters = '?participant='+ participant_id + '&got_prize=' + got_prize
      full_url = base_url + parameters;
      $.get(full_url, function(data){
      }).done(function() {
        Turbolinks.visit(document.URl)
      }).fail(function() {
        alert('Something bad happened. Please try again later...'); 
      });
    }
  });

  $('.edit_got_prize').change(function() {
    var participant_id = $(this).val(); 
    if($(this).is(":checked")) { 
       var got_prize = 'true'
     }else{  
       var got_prize = 'false'
     }
     base_url = '/main/mark_got_prize.json'
     parameters = '?participant='+ participant_id + '&got_prize=' + got_prize
     full_url = base_url + parameters;
     $.get(full_url, function(data){
       }).done(function() {
       }).fail(function() {
         alert('Something bad happened. Please try again later...'); 
     });
  });

  $('.not_complete_baby').change(function() {
    if($(this).is(":checked")) {
      var participant_id = $(this).val();
      $(this).attr('disabled', 'disabled');  
      var baby_complete = 'true'
      base_url = '/main/mark_baby_complete.json'
      parameters = '?participant='+ participant_id + '&baby_complete=' + baby_complete
      full_url = base_url + parameters;
      $.get(full_url, function(data){
      }).done(function() {
        Turbolinks.visit(document.URl)
      }).fail(function() {
        alert('Something bad happened. Please try again later...'); 
      });
    }
  });

    $('.edit_baby_complete').change(function() {
    var participant_id = $(this).val(); 
    if($(this).is(":checked")) { 
       var baby_complete = 'true'
     }else{  
       var baby_complete = 'false'
     }
     base_url = '/main/mark_baby_complete.json'
     parameters = '?participant='+ participant_id + '&baby_complete=' + baby_complete
     full_url = base_url + parameters;
     $.get(full_url, function(data){
       }).done(function() {
       }).fail(function() {
         alert('Something bad happened. Please try again later...'); 
     });
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
    }).done(function(){
      Turbolinks.visit(document.URl)
    }).fail(function(){
      alert('Something is borked! Try again later.')
    });
  }
}


function register(group, staff){
  var first_name = $("#first_name").val();
  var last_name = $("#last_name").val();
  var age = $("#age").val();
  var grade = $("#grade").val();
  var school = $("#school").val();
  var zip_code = $("#zip_code").val();
  var home_library = $("#home_library").val();
  var club = group;
  var email = $("#email").val();
  var library_card = $("#library_card").val();
  var message_div = "#messages"
  if ((group == 'teen' || group == 'youth') && staff != 'staff'){
    if (first_name.length == "0" || last_name.length == "0" || age.length == "0" || grade == null || grade.length == "0" || school == null || school.length == "0" || zip_code.length == "0" || home_library == null || home_library.length == "0") {
      $(message_div).html('<h3>Missing required fields</h3>');
      check_fields(); 
    }else{ 
      base_url = '/main/register.json'
      parameters = '?first_name='+ encodeURIComponent(first_name) + '&last_name=' + encodeURIComponent(last_name) + '&age=' + encodeURIComponent(age) + '&grade=' + encodeURIComponent(grade) + '&school=' + encodeURIComponent(school) + '&zip_code=' + encodeURIComponent(zip_code) + '&home_library=' + encodeURIComponent(home_library) + '&club=' + encodeURIComponent(club) + '&email=' + encodeURIComponent(email) + '&library_card=' + encodeURIComponent(library_card)
      full_url = base_url + parameters;
      $.get(full_url, function(data){
      }).done(function() {
        $(message_div).html("<h3>Congratulations, you've successfully registered for TADL Summer Reading Club!  Please be sure to stop by your home library to pick up your reading kit.  To find an upcoming event click here.</h3>");   
      }).fail(function() {
        $(message_div).html('<h3>Something bad happened. Please try again later...</h3>'); 
      });
    }
  }else if ((group == 'baby' || group == 'adult') && staff != 'staff') {
    if (first_name.length == "0" || last_name.length == "0" || age.length == "0" || zip_code.length == "0" || home_library == null || home_library.length == "0") {
      $(message_div).html('<h3>Missing required fields</h3>');
      check_fields();
    }else{
      base_url = '/main/register.json'
      parameters = '?first_name='+ encodeURIComponent(first_name) + '&last_name=' + encodeURIComponent(last_name) + '&age=' + encodeURIComponent(age) + '&grade=' + encodeURIComponent(grade) + '&school=' + encodeURIComponent(school) + '&zip_code=' + encodeURIComponent(zip_code) + '&home_library=' + encodeURIComponent(home_library) + '&club=' + encodeURIComponent(club) + '&email=' + encodeURIComponent(email) + '&library_card=' + encodeURIComponent(library_card)
      full_url = base_url + parameters;
      $.get(full_url, function(data){
      }).done(function() {
        $(message_div).html('<h3>Congratulations, you have successfully registered for TADL Summer Reading Club!  Please be sure to stop by your home library to pick up your reading kit.  To find an upcoming event <a href="http://www.tadl.org/events/556">click here</a>.</h3>');   
      }).fail(function() {
        $(message_div).html('<h3>Something bad happened. Please try again later...</h3>'); 
      });
    }
  }else if (staff == 'staff'){
    if (first_name.length == "0" || last_name.length == "0") {
      $(message_div).html('<h3>Missing required fields</h3>');
      check_fields('staff');
    }else{
      base_url = '/main/register.json'
      parameters = '?first_name='+ encodeURIComponent(first_name) + '&last_name=' + encodeURIComponent(last_name) + '&age=' + encodeURIComponent(age) + '&grade=' + encodeURIComponent(grade) + '&school=' + encodeURIComponent(school) + '&zip_code=' + encodeURIComponent(zip_code) + '&home_library=' + encodeURIComponent(home_library) + '&club=' + encodeURIComponent(club) + '&email=' + encodeURIComponent(email) + '&library_card=' + encodeURIComponent(library_card)
      full_url = base_url + parameters;
      $.get(full_url, function(data){
      }).done(function() {
        $(message_div).html('<h3>Congratulations, you have successfully registered for TADL Summer Reading Club!  Please be sure to stop by your home library to pick up your reading kit.  To find an upcoming event <a href="http://www.tadl.org/events/556">click here</a>.</h3>');   
      }).fail(function() {
        $(message_div).html('<h3>Something bad happened. Please try again later...</h3>'); 
      });
    }
  }
}

function update_patron(id){
  var first_name = $("#first_name").val();
  var last_name = $("#last_name").val();
  var age = $("#age").val();
  var grade = $("#grade").val();
  var school = $("#school").val();
  var zip_code = $("#zip_code").val();
  var home_library = $("#home_library").val();
  var email = $("#email").val();
  var library_card = $("#library_card").val();
  base_url = '/main/update_patron.json'
  parameters = '?id='+ id +'&first_name='+ encodeURIComponent(first_name) + '&last_name=' + encodeURIComponent(last_name) + '&age=' + encodeURIComponent(age) + '&grade=' + encodeURIComponent(grade) + '&school=' + encodeURIComponent(school) + '&zip_code=' + encodeURIComponent(zip_code) + '&home_library=' + encodeURIComponent(home_library) + '&email=' + encodeURIComponent(email) + '&library_card=' + encodeURIComponent(library_card)
  full_url = base_url + parameters;
  $.get(full_url, function(data){
  }).done(function() {
      alert('Patron has been updated. Nice work!'); 
      Turbolinks.visit(document.URl)
  }).fail(function() {
      alert('Something bad happened. Please try again later...'); 
  });

}


function delete_award(id){
  url = '/main/revoke_award.json?id=' + id
  div = '#edit_' + id
  $.get(url, function(data){
  }).done(function() {
      $(div).remove();
  }).fail(function() {
      alert('Something bad happened. Please try again later...'); 
  });

}

function check_fields(staff){
  if(staff != 'staff'){
    $('.required').removeClass('highlight');
    $('.required').each(function(){
      if ($.trim($(this).val()).length == 0){
        $(this).addClass('highlight');
      }
    })
  }else{
    $('.required_staff').removeClass('highlight');
    $('.required_staff').each(function(){
      if ($.trim($(this).val()).length == 0){
        $(this).addClass('highlight');
      }
    })
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

function filter_patrons(){
  var club_value = $('input[name="club"]:checked').val()
  var library_value = $('input[name="library"]:checked').val()
  var club = 'group='+ encodeURIComponent(club_value)+ '&'
  var library = 'location='+encodeURIComponent(library_value)+'&'
  var url = '/main/patron_list?'


  if (club_value == 'all' && library_value != 'all') {
    var params = library
    url = '/main/patron_list?' + params
  } else if (library_value == 'all' && club_value != 'all'){
    var params = club
    url = '/main/patron_list?' + params
  } else if (library_value != 'all' && club_value != 'all'){
    var params = club + library
    url = '/main/patron_list?' + params
  }

  if($("#winner").is(':checked')){
    url = url + 'winner=yes' 
  }
  Turbolinks.visit(url)
}

function download_as_csv(){
  var filters = window.location.search;
  var url = '/main/patron_list.csv' + filters
  window.open(url)

}














