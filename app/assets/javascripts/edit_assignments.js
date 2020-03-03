$("tr.item").each(function() {
  $this = $(this)
  var value = $this.find("span.value").html();
  var quantity = $this.find("input.quantity").val();
});



//$(document).on('change', 'input[type="number"]', function() {
//	  
//	
//	$update = $(this).val() * 2 
//	
//	$name = $(this).attr('name')
//	
//	$se_id =  $name.split('[')[1].split(']')[0].split('_')[1]
//	
//	$id = "#sec_" + $se_id ;
//	
//	$pre_val = parseFloat($($id).text()); 
//		
//	$new_val = ($pre_val - $update )
//		
//	$($id).html( $new_val );
//	
//	$hid = ".hsec_" + $se_id ;
//	
//	if ($new_val == 0){
//				
//		$($hid).removeClass('danger').addClass('success');
//
//	}
//	
// 
//	});

$(document).on('click', '#claculate_stat', function() {
				
	
	$('#missing_div_cs').append( $('th[id^="dangerMissing_CS"]').length)
	$('#extra_sections_cs').append( $('th[id^="extra_CS"]').length)
	$('#double_ass_cs').append( $('th[id^="warningStudent_CS"]').length)
	$('#half_ass_cs').append( $('th[id^="infoStudent_CS"]').length)
	$('#missing_ass_cs').append( $('th[id^="dangerStudent_CS"]').length)
	$('#missing_ta_cs').append( $('#missing_ta_CS').text())

	$('#missing_div_ece').append( $('th[id^="dangerMissing_ECE"]').length)
	$('#extra_sections_ece').append( $('th[id^="extra_ECE"]').length)
	$('#double_ass_ece').append( $('th[id^="warningStudent_ECE"]').length)
	$('#half_ass_ece').append( $('th[id^="infoStudent_ECE"]').length)
	$('#missing_ass_ece').append( $('th[id^="dangerStudent_ECE"]').length)
	$('#missing_ta_ece').append( $('#missing_ta_ECE').text())
	
	$('.groove').each(function(){
				
			student = $(this).find('input[type=checkbox]').attr('student')
							
			find_students = 'input[name="fixed_gta"][student=' + student + ']'
				
			$(find_students).each(function(){
					$(this).parent().addClass('groove');
			});
	});
	
	
	          
	alert("done");
});

$(document).on('click', '#show_cs_sections', function() {
	
    $("#show_cs_sections").hide();
    $("#hide_cs_sections").show();
    
    $(".cs_class").show();

});

$(document).on('click', '#hide_cs_sections', function() {
	
    $("#show_cs_sections").show();
    $("#hide_cs_sections").hide();
    
    $(".cs_class").hide();

});

$(document).on('click', '#show_ece_sections', function() {
	
    $("#show_ece_sections").hide();
    $("#hide_ece_sections").show();
    
    $(".ece_class").show();
    
    


});

$(document).on('click', '#hide_ece_sections', function() {
	
    $("#show_ece_sections").show();
    $("#hide_ece_sections").hide();
    
    $(".ece_class").hide();

});


$(document).on('click', '#show_cs', function() {
	
    $("#show_cs").hide();
    $("#hide_cs").show();
    
    $(".cs_student").show();

});

$(document).on('click', '#hide_cs', function() {
	
    $("#show_cs").show();
    $("#hide_cs").hide();
    
    $(".cs_student").hide();





});

$(document).on('click', '#show_ece', function() {
	
    $("#show_ece").hide();
    $("#hide_ece").show();
    
    $(".ece_student").show();
    
    


});

$(document).on('click', '#hide_ece', function() {
	
    $("#show_ece").show();
    $("#hide_ece").hide();
    
    $(".ece_student").hide();

});

$(document).on('click', '#show_options', function() {
	
    $("#options").show();
    $("#show_options").hide();
    

});

$(document).on('click', '#hide_options', function() {
	
    $("#options").hide();
    $("#show_options").show();


});

$(document).on('click', '#scan', function() {
	message = ""
	//find = '#fixgta'
    find = 'input[name="fixed_gta"]'
	$(find).each(function(){
		$box = $(this)
		student_id = $box.attr('student')
		sub_find = 'input[id="assignment_cell"][student="' + student_id + '"]'
		sum = 0
		$(sub_find).each(function(){
			$sub_box = $(this)
			if($sub_box.is(':checked')){
				sum += Number($sub_box.parent().parent().find('select').val())
			}
		});
		checksum = 0
	    checksum += Number($box.attr('fte'))
	    //console.log("\n\nchecksum is: " + checksum + "\nsum is: " + sum)
	    if(sum > checksum){
	    	message += "Warning: " + $box.attr('student_name') + " is listed at " + checksum + " fte, and you have fixed them at " + sum + " fte. If you do not alter this user, the solver will fail.\n"
	    }
	    
	});
	if (message != ""){
    	alert(message)
    }
    else{
    	alert("No fixed errors found.")
    }
});

$(document).on('change', '#fixsec', function() {
	$this = $(this)
	section_id = $this.attr('section')
    find = 'input[section="' + section_id + '"]'
    if($this.is(':checked')){
    	$(find).each(function(){
			
			find2 = 'div[section="' + section_id + '"]'

			$(find2).each(function(){
				
				$div = $(this)
				st_id = $div.attr('student')
				
				if ( $div.children().length == 0 ) {
	
					
					var checkbox_html = '<input type="checkbox" value="true"  name="assignments_is_fixed['+ st_id + '_' + section_id + ']" section="' + section_id +'"  student="' + st_id + '" />'; 
	  			
					$div.append(checkbox_html);
				}
				
			});
			
			$box = $(this)
			$box.prop('checked', true)
			
			
		});
    }else{
		$(find).each(function(){
			$box = $(this)
			$box.prop('checked', false)
		});
	}	
});

$(document).on('change', '#fixgta', function() {
	$this = $(this)
	student_id = $this.attr('student')
    find = 'input[student="' + student_id + '"]'
    if($this.is(':checked')){
    	$(find).each(function(){
    		
    		find2 = 'div[student="' + student_id + '"]'

			$(find2).each(function(){
				
				$div = $(this)
				se_id = $div.attr('section')
				
				if ( $div.children().length == 0 ) {
					var checkbox_html = '<input type="checkbox" value="true"  name="assignments_is_fixed['+ student_id + '_' + se_id + ']" section="' + se_id +'"  student="' + student_id + '" />'; 
					$div.append(checkbox_html);
				}
				
				
			});
    		
    		
			$box = $(this)
			$box.prop('checked', true)
		});
    }else{
		$(find).each(function(){
			$box = $(this)
			$box.prop('checked', false)
		});
	}	
});

//Fix/unfix all

$(document).on('click', '#fix_Bad', function() {
	$('.groove').each(function(){
			section = $(this).find('input[type=checkbox]').attr('section')
			student = $(this).find('input[type=checkbox]').attr('student')

			find_sections = 'input[name="fixed_section"][section=' + section + ']'
			find_students = 'input[name="fixed_gta"][student=' + student + ']'

			$(find_students).each(function(){
				$box = $(this)
				if(!$box.is(':checked')){
					$box.trigger('click')
				}
			});
		});
});

$(document).on('click', '#unfix_Bad', function() {
	$('.groove').each(function(){
			section = $(this).find('input[type=checkbox]').attr('section')
			student = $(this).find('input[type=checkbox]').attr('student')

			find_sections = 'input[name="fixed_section"][section=' + section + ']'
			find_students = 'input[name="fixed_gta"][student=' + student + ']'

			$(find_students).each(function(){
				$box = $(this)
				if($box.is(':checked')){
					$box.trigger('click')
				}
			});
		});
});

$(document).on('click', '#fix_CS', function() {
	find = 'input[subject="CS"]'
	$(find).each(function(){
			$box = $(this)
			if(!$box.is(':checked')){
				$box.trigger('click')
			}
		});
});

$(document).on('click', '#fix_ECE', function() {
	find = 'input[subject="ECE"]'
	$(find).each(function(){
			$box = $(this)
			if(!$box.is(':checked')){
				$box.trigger('click')
			}
		});
});

$(document).on('click', '#fix_Red', function() {
	find = 'input[student_status="Red"]'
	$(find).each(function(){
			$box = $(this)
			if(!$box.is(':checked')){
				$box.trigger('click')
			}
		});
});

$(document).on('click', '#unfix_CS', function() {
	find = 'input[subject="CS"]'
	$(find).each(function(){
			$box = $(this)
			if($box.is(':checked')){
				$box.trigger('click')
			}
		});
});

$(document).on('click', '#unfix_ECE', function() {
	find = 'input[subject="ECE"]'
	$(find).each(function(){
			$box = $(this)
			if($box.is(':checked')){
				$box.trigger('click')
			}
		});
});

$(document).on('click', '#unfix_Red', function() {
	find = 'input[student_status="Red"]'
	$(find).each(function(){
			$box = $(this)
			if($box.is(':checked')){
				$box.trigger('click')
			}
		});
});

$(document).on('click', '#fix_CSs', function() {
	find = 'input[ta_major="CS"]'
	$(find).each(function(){
			$box = $(this)
			if(!$box.is(':checked')){
				$box.trigger('click')
			}
		});
});

$(document).on('click', '#fix_ECEs', function() {
	find = 'input[ta_major="ECE"]'
	$(find).each(function(){
			$box = $(this)
			if(!$box.is(':checked')){
				$box.trigger('click')
			}
		});
});

$(document).on('click', '#fix_Reds', function() {
	find = 'input[status="Red"]'
	$(find).each(function(){
			$box = $(this)
			if(!$box.is(':checked')){
				$box.trigger('click')
			}
		});
});

$(document).on('click', '#unfix_CSs', function() {
	find = 'input[ta_major="CS"]'
	$(find).each(function(){
			$box = $(this)
			if($box.is(':checked')){
				$box.trigger('click')
			}
		});
});

$(document).on('click', '#unfix_ECEs', function() {
	find = 'input[ta_major="ECE"]'
	$(find).each(function(){
			$box = $(this)
			if($box.is(':checked')){
				$box.trigger('click')
			}
		});
});

$(document).on('click', '#unfix_Reds', function() {
	find = 'input[status="Red"]'
	$(find).each(function(){
			$box = $(this)
			if($box.is(':checked')){
				$box.trigger('click')
			}
		});
});


$(document).on('click', '#fix_all', function() {
	//value = $('#assignment_allow_double_ass').is(':checked')
	//console.log(value)
	
	
	/*$('div[id^="check_show_me_"]').each(function(){
		
		
		$id = $(this).attr('id').split('_')
		$st_id = $id[3]
		$se_id = $id[4]
		
		$div = $(this)
		
		if ( $div.children().length == 0 ) {
					
			var checkbox_html = '<input type="checkbox" value="true"  name="assignments_is_fixed['+ $st_id + '_' + $se_id + ']" section="' + $se_id +'"  student="' + $st_id + '" />'; 
	  			
				$div.append(checkbox_html)			
		}
		
	});*/


  $('input:checkbox').prop('checked', true);
        	
    
  
	
	//if(value == false){
    //	console.log("In if")
    	//$('#fixCS').trigger('click')
    	//$('#fixECE').trigger('click')
    //}
});

$(document).on('click', '#unfix_all', function() {
	value = $('#assignment_allow_double_ass').is(':checked')
    $('input:checkbox').prop('checked', false);
    if(value == true){
    	$('#assignment_allow_double_ass').prop('checked', true);
    }
});