var inputVal,
	userInput = false,
	signup = false


$('input').focus(function(){
	inputVal = $(this).val()
	$(this).val('')
	$(this).keyup(function(){
		userInput = true
	})
		
}).blur(function(){
	userInput ? null : $(this).val(inputVal)
})


$('#signup_button').click(function(){
	if (!signup){
		$('#login_wrapper').fadeOut()
		$('#signup_wrapper').fadeIn()	
		$(this).children().html('Log In')
		signup = !signup
	}
	else{
		$('#signup_wrapper').fadeOut()
		$('#login_wrapper').fadeIn()	
		$(this).children().html('Sign Up')
		signup = !signup	
	}
	
})