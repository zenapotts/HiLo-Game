// ----------------------------------------------------------------------------------------------------
//		This file contains the javascript functions for the Hi-Lo Game.
//		These functions perform client side validation and display error messages
//		Functions in this file include;
//		validateName(), validateMax(), validateGuess()
//		For more detailed information see function header comments below 	    
// ----------------------------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------------------------
//		Function:       validateName()
//		Purpose:        This function performs validation on the name the user has entered, 
//						and controls the visibility of the error messsages they recieve. 
//						Names are invalid when they are blank and valid otherwise
//		Parameter(s):   None
//		Return:         validationStatus: True or False
// ----------------------------------------------------------------------------------------------------
function validateName()
{
	nameError.innerHTML="";								//Clear error

	var validationStatus = true;						//Assume true

	var tmpName = document.GameForm.nameValue.value;	//Get name value

	if(tmpName.trim().length == 0)						//If this is true name is blank
	{
		nameError.innerHTML = "Error: Name cannot be blank!";
		validationStatus = false;						//Name fails validation
	}

	if(validationStatus == true)						//Name is none empty
	{
		nameDiv.style.display="none";					//Hide name div
		maxDiv.style.visibility="visible";				//Display max guess div

		//Prompt for the user by name to enter their max guess
		var promtString = tmpName +=", what is the maximum number you would like to guess?";
		namePrompt.innerHTML = tmpName;
	}
	
	return validationStatus;	
}

// ----------------------------------------------------------------------------------------------------
//		Function:       validateMax()
//		Purpose:        This function performs validation on the max guess the user has entered, 
//						and controls the visibility of the error messsages they recieve. Valid max
//						guess cannot be blank and must be numeric  
//		Parameter(s):   None
//		Return:         validationStatus2: True or False
// ----------------------------------------------------------------------------------------------------
function validateMax()
{
	maxError.innerHTML="";							//Clear error

	var validationStatus2 = false;					//Assume false

	var validNumeric = /^-?\d+(\.\d{1,2})?$/;		//This will accept numeric values, - and .

	var tmpMax = document.GameForm.maxValue.value;	//get max number

	var validSpecificNumeric = /^-?\d+$/;			//only integers
	
	if(tmpMax.trim().length == 0)					//empty max
	{
		maxError.innerHTML = "Error: Maximum number cannot be blank!";
		validationStatus2 = false;
	}
	else
	{
		if(tmpMax.match(validNumeric))				//it's a number
		{
			if(tmpMax.match(validSpecificNumeric))	//valid number
			{
				validationStatus2 = true;
			}
			else
			{
				//bad character '.'
				maxError.innerHTML = "Error: Decimals are considered out of range! <br>Only integers will be accepted.";
				validationStatus2 = false;
			}
		}
		else										//non number enteries receieve error
		{
			maxError.innerHTML = "Error: Maximum number must be numeric!";
			validationStatus2 = false;
		}
	}

	return validationStatus2;
}

// ----------------------------------------------------------------------------------------------------
//		Function:       validateGuess()
//		Purpose:        This function performs validation on the guess the user has entered, 
//						and controls the visibility of the error messsages they recieve. Valid guesses
//						cannot be blank and must be numeric  
//		Parameter(s):   None
//		Return:         validationStatus3: True or False
// ----------------------------------------------------------------------------------------------------
function validateGuess()
{
	guessError.innerHTML="";								//clean up error

	var validationStatus3 = false;							//assume false

	var validNumeric = /^-?\d+(\.\d{1,2})?$/;				//valid numeric 

	var tmpGuess = document.GameForm.guessValue.value;		//get guess

	var validSpecificNumeric = /^-?\d+$/;					//only integers
	
	if(tmpGuess.trim().length == 0)							//empty guess
	{
		guessError.innerHTML = "Error: Guess number cannot be blank!";
		validationStatus3 = false;
	}
	else
	{
		if(tmpGuess.match(validNumeric))				//numeric answer
		{
			if(tmpGuess.match(validSpecificNumeric))
			{
				validationStatus3 = true;
			}
			else
			{
				//contains bad char '.'
				guessError.innerHTML = "Error: Decimals are considered out of range! <br>Only integers will be accepted.";
				validationStatus3 = false;
			}
		}
		else											//none numeric
		{
			guessError.innerHTML = "Error: Guess number must be numeric!";
			validationStatus3 = false;
		}
	}

	return validationStatus3;
}

