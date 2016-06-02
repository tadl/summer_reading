var load_functions;
load_functions = function() {
  Turbolinks.pagesCached(0);

  var loading = 'false'

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

  $('.edit_inactive').change(function() {
    var participant_id = $(this).val(); 
    if($(this).is(":checked")) { 
       var inactive = 'true'
     }else{  
       var inactive = 'false'
     }
     base_url = '/main/mark_inactive.json'
     parameters = '?participant='+ participant_id + '&inactive=' + inactive
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
$(document).on('page:fetch', startSpinner).delay(3000);
$(document).on('page:receive', stopSpinner);

function startSpinner(){
  loading = 'true'
  setTimeout(still_loading, 500);
}

function still_loading(){
  if (loading == 'true'){
    $('#content').css('opacity', .5);
    $('#loading').show(0);
  }
}

function stopSpinner(){
  loading = 'false'
  $('#loading').hide(0);
  $('#content').css('opacity', 1);
}


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
  var phone = $("#phone").val();
  var email = $("#email").val();
  var library_card = $("#library_card").val();
  var message_div = "#messages"
  var success_msg = "<div class='good_text'><h3 style='text-align: center'>Congratulations, you've successfully registered for TADL Summer Reading Club!</h3> <p>Please be sure to stop by your home library to pick up your reading kit.</p>  <p>To find an upcoming event <a href='http://www.tadl.org/events/556'>click here</a>.</p> <p>To register another patron <a href='/main/index'>click here</a>.</p></div>"
  if ((group == 'teen' || group == 'youth') && staff != 'staff'){
    if (first_name.length == "0" || last_name.length == "0" || phone.length < '7' || !phone.match(/\(?([0-9]{3})\)?([ .-]?)([0-9]{3})\2([0-9]{4})/) || age.length == "0" || grade == null || grade.length == "0" || school == null || school.length == "0" || zip_code.length == "0" || home_library == null || home_library.length == "0") {
      $(message_div).html('<h3>Missing required fields</h3>');
      if(!phone.match(/\(?([0-9]{3})\)?([ .-]?)([0-9]{3})\2([0-9]{4})/)){
         $(message_div).append('<h3>Invalid Phone Number</h3>');
      }
      check_fields(); 
    }else{ 
      base_url = '/main/register.json'
      parameters = '?first_name='+ encodeURIComponent(first_name) + '&phone='+ phone  + '&last_name=' + encodeURIComponent(last_name) + '&age=' + encodeURIComponent(age) + '&grade=' + encodeURIComponent(grade) + '&school=' + encodeURIComponent(school) + '&zip_code=' + encodeURIComponent(zip_code) + '&home_library=' + encodeURIComponent(home_library) + '&club=' + encodeURIComponent(club) + '&email=' + encodeURIComponent(email) + '&library_card=' + encodeURIComponent(library_card)
      full_url = base_url + parameters;
      $.get(full_url, function(data){
      }).done(function() {
        $('#sign_up_form').remove();
        $(message_div).html(success_msg);   
      }).fail(function() {
        $(message_div).html('<h3>Sorry. Something went wrong. Please try again later...</h3>'); 
      });
    }
  }else if ((group == 'baby' || group == 'adult') && staff != 'staff') {
    if (first_name.length == "0" || last_name.length == "0" || phone.length < '7' || !phone.match(/\(?([0-9]{3})\)?([ .-]?)([0-9]{3})\2([0-9]{4})/) || age.length == "0" || zip_code.length == "0" || home_library == null || home_library.length == "0") {
      $(message_div).html('<h3>Missing required fields</h3>');
      if(!phone.match(/\(?([0-9]{3})\)?([ .-]?)([0-9]{3})\2([0-9]{4})/)){
         $(message_div).append('<h3>Invalid Phone Number</h3>');
      }
      check_fields();
    }else{
      base_url = '/main/register.json'
      parameters = '?first_name='+ encodeURIComponent(first_name) + '&phone='+ phone +'&last_name=' + encodeURIComponent(last_name) + '&age=' + encodeURIComponent(age) + '&grade=' + encodeURIComponent(grade) + '&school=' + encodeURIComponent(school) + '&zip_code=' + encodeURIComponent(zip_code) + '&home_library=' + encodeURIComponent(home_library) + '&club=' + encodeURIComponent(club) + '&email=' + encodeURIComponent(email) + '&library_card=' + encodeURIComponent(library_card)
      full_url = base_url + parameters;
      $.get(full_url, function(data){
      }).done(function() {
        $('#sign_up_form').html(success_msg);
      }).fail(function() {
        $(message_div).html('<h3>Sorry. Something went wrong. Please try again later...</h3>'); 
      });
    }
  }else if (staff == 'staff'){
    if (first_name.length == "0" || last_name.length == "0") {
      $(message_div).html('<h3>Missing required fields</h3>');
      check_fields('staff');
    }else{
      if($("#got_kit").is(":checked")){
        var got_kit = '&got_kit=true'
      }else{
        var got_kit = ''
      }
      base_url = '/main/register.json'
      parameters = '?first_name='+ encodeURIComponent(first_name) + '&phone='+ phone + '&last_name=' + encodeURIComponent(last_name) + '&age=' + encodeURIComponent(age) + '&grade=' + encodeURIComponent(grade) + '&school=' + encodeURIComponent(school) + '&zip_code=' + encodeURIComponent(zip_code) + '&home_library=' + encodeURIComponent(home_library) + '&club=' + encodeURIComponent(club) + '&email=' + encodeURIComponent(email) + '&library_card=' + encodeURIComponent(library_card) + got_kit
      full_url = base_url + parameters;
      $.get(full_url, function(data){
      }).done(function() {
        $('#sign_up_form').html(success_msg); 
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
  var club = $("#club").val();
  var phone = $("#phone").val();
  base_url = '/main/update_patron.json'
  parameters = '?id='+ id +'&first_name='+ encodeURIComponent(first_name) + '&last_name=' + encodeURIComponent(last_name) + '&phone=' + phone + '&age=' + encodeURIComponent(age)  + '&zip_code=' + encodeURIComponent(zip_code) + '&home_library=' + encodeURIComponent(home_library) + '&email=' + encodeURIComponent(email) + '&library_card=' + encodeURIComponent(library_card) + '&club=' + club
  if(grade || school){
    var school_stuff = '&grade=' + encodeURIComponent(grade) + '&school=' + encodeURIComponent(school)
    full_url = base_url + parameters + school_stuff;
  }else{
    full_url = base_url + parameters;
  }
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

function search_by_name(mobile){
 if(mobile == 'true'){
  var target_div = '.search_by_name_mobile'
 }else{
  var target_div = '.search_by_name'
 }
 var name = $(target_div).val();
 var clean_name = encodeURIComponent(name);  
  if (name){
    var url = '/main/search_by_name?name=' + clean_name
    Turbolinks.visit(url)
     }else{
    alert("enter a name!");  
     }     
}

function search_by_card(mobile){
 if(mobile == 'true'){
  var target_div = '.search_by_card_mobile'
 }else{
  var target_div = '.search_by_card'
 }
 var card = $(target_div).val();
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
  var url = '/main/patron_list_export.json' + filters
  $.get(url, function(data){
  }).done(function() {
      alert('An email containing the requested data will be sent to your tadl.org email account within the next two minutes.'); 
  }).fail(function() {
      alert('Error: You do not have permission to access this feature'); 
  });

}

function show_award_div(patron){
  var div_show = "#award_" + patron
  $(div_show).show();
}

function hide_award_div(patron){
  var div_show = "#award_" + patron
  $(div_show).hide(); 
}

function show_hour_div(patron){
  var div_show = "#hour_" + patron
  $(div_show).show();
}

function hide_hour_div(patron){
  var div_show = "#hour_" + patron
  $(div_show).hide(); 
}



function self_reward(patron, experience, card, image){
  var read = $('#award_read').val();
  var did =  $('#award_did').val();
  var url = '/main/self_award_patron.json?participant=' + patron + '&experience=' + experience + '&card=' + card
  var target_div = "#award_form_" + patron
  var show_image = '<img src="' + image + '">'
  var print_link = '<a target="_blank" href="'+ image +'">Click Here for Printable Badge</a>'
  if(read && did){
    $.get(url, function(data){
      }).done(function(){
        $.fancybox.open({ 
        'scrolling'     : 'no',
        'overlayOpacity': 0.1,
        'afterClose' : function() {Turbolinks.visit(document.URl)},
        'content' : '<center><h2>Congratulations</h2>'+ show_image +'<p>Be sure to visit your library to pick up your reward</p>'+ print_link +'</center>'
      }); 
      }).fail(function(){
        Turbolinks.visit(document.URl)
      });
  }else{
    $('#messages').html('<h4>Please let us know what you read and what you did</h4>');
    $('.required').each(function(){
      if ($.trim($(this).val()).length == 0){
        $(this).addClass('highlight');
      }
    })
  }

}


function self_reward_cancel(patron){
  var target_div = "#award_form_" + patron
  var div_show = "#award_patron_" + patron
  $(div_show).show(); 
  $(target_div).html("");
}

function award_prize(id){
  url = '/main/award_prize.json?id=' + id
  $.get(url, function(data){
  }).done(function() {
      Turbolinks.visit(document.URl)
  }).fail(function() {
      alert('Something bad happened. Please try again later...'); 
  });
}

function add_hours(week, id, card){
  hour_div = '#week_' + week
  patron_div = '#hour_' + id
  hours = $(hour_div).val()
  url = '/main/self_record_hours.json?id=' + id +'&week=' + week + '&hours=' + hours + '&card=' + card
  $.get(url, function(data){
  }).done(function() {
      $.fancybox.open({ 
        'scrolling'     : 'no',
        'overlayOpacity': 0.1,
        'content' : '<center><h2>Thanks for Upating Your Hours!</h2></center>'
      });
      $(patron_div).load('/main/self_record_hours_refresh?id=' + id);
  }).fail(function() {
      alert('Something bad happened. Please try again later...'); 
  });
}