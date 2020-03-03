

function can_trade(student, fte){
	var find = 'button[student="' + student + '"]'
	var found_match = false
	$(find).each(function() {
		$this = $(this)
		candidate_fte = $this.attr('fte') == 0? 0: ($this.attr('fte') > .25? .50 : .25)
		switch_fte = fte == 0? 0 : (fte > .25 ? .50 : .25)
		if(candidate_fte == switch_fte){
			found_match = true
			return false
		}
	});
	if(found_match)
		return true;
	return false;
}

function offer_trade(one, two){
	td = one.parent()
	trade_td = two.parent()
	trade_tr = trade_td.parent()

	name = trade_tr.find('th').find('span').text()
	td.append("<p>Trade with: " + name + ":</p>")

	section_a = one.attr('section')
	student_a = one.attr('student')
	fte = one.attr('fte')
	section_b = two.attr('section')
	student_b = two.attr('student')

	var $newbutton = $("<button>", {id: "trade", "type": "button", "text":"Trade", "student_a": student_a,
									"student_b": student_b, "section_a": section_a, 
									"section_b": section_b, "fte": fte });

	td.append($newbutton);
}

$(document).on('click', '#trade', function(){
	$this = $(this)
	section_a = $this.attr('section_a')
	student_a = $this.attr('student_a')
	fte = $this.attr('fte')
	section_b = $this.attr('section_b')
	student_b = $this.attr('student_b')

	if(fte == '0.0' || fte == 0)
		fte_str = '0.0'
	else if(fte == .25 || fte == '.25')
		fte_str = '0.25'
	else
		fte_str = '0.50'

	//Set original fte for student A to 0
	td = $this.parent()
	td.find('select').val('0.0')

	//Set original fte for student B to 0
	find_b = 'button[section="' + section_b + '"][student="' + student_b + '"]'
	b = $(find_b)
	b.parent().find('select').val('0.0')

	//Set new fte for student A to new FTE value
	find_a_new = 'button[section="' + section_b + '"][student="' + student_a + '"]'
	new_a = $(find_a_new)
	new_a.parent().find('select').val(fte_str)

	//Set new fte for student B to new FTE value
	find_b_new = 'button[section="' + section_a + '"][student="' + student_b + '"]'
	new_b = $(find_b_new)
	new_b.parent().find('select').val(fte_str)

});

$(document).on('click', '#suggest', function() {

	var change = $(this)
	var placeholder = change
    var candidate = change
    var score = 0

    var section = change.attr('section')
    var find = 'button[section="' + section + '"]'


	var better_can = 0
	var fte_dont_match = 0
	var fte_nonzer = 0
	var same_obj = 0

	var debug = false;

	$(find).each(function() {
      $this = $(this)
      debug = false;

	if($this.attr('score') > 1){
		debug = true;
	}

	 if(change.attr('student') !== $this.attr('student')){ 		
	 	    	//This line ensures our candidate is not already assigned to the same course
		 if($this.attr('fte') == 0){
		 			//Function will see if there exists a valid fte swap between the two (e.g. .25 for .25)
		 	if(can_trade($this.attr('student'), change.attr('fte')) == true){
		 		if(candidate.attr('student') == change.attr('student')){
		 			candidate = $this
		 		}
		 		else if($this.attr('score') > candidate.attr('score')){
				 	candidate = $this
		 		} else{} 
		 	} else{}
		 } else{}
	 } else{}
	});
	offer_trade(change, candidate)
});



$("tr.item").each(function() {
  $this = $(this)
  var value = $this.find("span.value").html();
  var quantity = $this.find("input.quantity").val();
});

$(document).on('change', '#fixsec', function() {

	$this = $(this)
	//console.log($this)
	section_id = $this.attr('section')
    find = 'input[section="' + section_id + '"]'


    if($this.is(':checked')){
    	$(find).each(function(){
			$box = $(this)
			//console.log($box)
			$box.prop('checked', true)
		});
    }else{
		$(find).each(function(){
			$box = $(this)
			//console.log($box)
			$box.prop('checked', false)
			//console.log("Checking: \n" + $box)
		});
	}	
});

$(document).on('change', '#fixgta', function() {

	$this = $(this)
	//console.log($this)
	student_id = $this.attr('student')
    find = 'input[student="' + student_id + '"]'


    if($this.is(':checked')){
    	$(find).each(function(){
			$box = $(this)
			//console.log("No: " + $box)
			$box.prop('checked', true)
		});
    }else{
		$(find).each(function(){
			$box = $(this)
			//console.log($box)
			$box.prop('checked', false)
			//console.log("Checking: \n" + $box)
		});
	}	
});

//Fix/unfix all

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

$(document).on('click', '#fix_all', function() {
    $('input:checkbox').prop('checked', true);
});

$(document).on('click', '#unfix_all', function() {
    $('input:checkbox').prop('checked', false);
});