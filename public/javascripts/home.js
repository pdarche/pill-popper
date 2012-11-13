
$( document ).ready(function(){

	$.get('/check_meds', function(data){
		var data = $.parseJSON(data)
		console.log("data", data)
		
		var ts = Math.round((new Date()).getTime() / 1000) 
			
		$.each(data.user, function(i){
			var classString = '.med.' + $.parseJSON(data.user[i]).medId,
				interval = Number($(classString).find('.interval').html()) * 60 * 60			
				userId = $.parseJSON(data.user[i]).userId,
				userString = '.user-name.' + userId

			if ( ts - $.parseJSON(data.user[i]).time_taken > interval ) {
				$(userString).parent().parent().append('<div>Pills to Take</div>')
			}
			else {
				$(classString).remove()
				$(userString).parent().parent().append('<div>No Pills to Take!</div>')
			} 

			console.log($(userString).parent().parent())
		})

		$.each(data.affiliate, function(i){
			var classString = '.med.' + $.parseJSON(data.affiliate[i]).medId,
				interval = Number($(classString).find('.interval').html()) * 60 * 60			
				userId = $.parseJSON(data.affiliate[i]).userId,
				userString = '.user-name.' + userId

			if ( ts - $.parseJSON(data.affiliate[i]).time_taken > interval ) {
				$(userString).parent().parent().append('<div>Pills to Take</div>')
			}
			else {
				$(classString).remove()
				$(userString).parent().parent().append('<div>No Pills to Take!</div>')
			} 

			console.log($(userString).parent().parent())
		})



	})

	$('.content_wrapper').click(function(){
		$(this).find('.medications').fadeIn()
	})

	$('.bottle').click(function(){
		$(this).parent().find('.med-info').fadeIn()
	})

	$('.take-button').click(function(){
		var serializedData,
			userId = getClass( $('.user-name').attr('class'), 1 ),
			medId = getClass( $(this).parent().attr('class'), 1 ),
			taken = true

		serializedData = "userId=" + userId + "&medId=" + medId + "&taken=" + taken

		$.ajax({
			url: '/take_med',
			type: 'POST',
			data: serializedData,
			success: function(){	
			},
			error: function(){
				alert("pizza")
			}
		})

		$(this).parent().fadeOut().queue(function(){
			$(this).remove();
			$(this).dequeue()	
		})
	})

	// Set drag scroll on first descendant of class dragger on both selected elements
	$('div.viewport').dragscrollable({dragSelector: '.bottle:first', acceptPropagatedEvent: false});

})

function getClass(classes, index){
    var split = classes.split(" ");
    return split[index];
 }
	 


