<!DOCTYPE html>
<!-------------------------------------------------------------------------------------------------------------
	This file contains the server side logic for the Hi-Lo game. Range checking is done on 	
	the max number, if it passes the user is show a guessing range and prompted to make a 
	guess. If the user submits a valid guess the range prompt will change until they
	submit a winning guess. When the user wins they will be given the option to play again
	if the user choses to play again their name will be retained and they will be 
	redirected to the max number page. Client-side validation is done using Javascript,
	functions can be found in the scripts.js file.
-------------------------------------------------------------------------------------------------------------->
<hmtl>
	<head>
		<title>Hi-Lo Game</title>
		<style type="text/css">
			body {
				background-color: #282923;
				font-family: Consolas, monaco, monospace;
				text-align: center;
			}
			h1 {
				color: #66D9EF;
				display: inline-block;
				border-style: solid;
				border-width: 3px;
				border-radius: 5px;
				border-color: #AE81FF;
			}
			p {
				font-size: 17px;
				color: #A6E22E;
			}
			input[type=text] {
				border: none;
				border-bottom: 5px solid orange;
			}
			.formWrapper {
				display: inline-block;
				border-style: dotted;
				border-color: #D8DB84;
				width: 500px;
				height: 300px;
			}
			.errorColor {
				color: #F92672;
			}
			.errorSpecial {
				color: #F92672;
			}
			.button {
				color: #75715E;
				border: 5px solid orange;
				padding: 3px 10px;
				border-radius: 16px;
			}
			.buttonPA {
				color: #75715E;
				border: 5px solid blue;
				padding: 3px 10px;
				border-radius: 16px;
			}
			.maxDiv {
				align-items: center;
			}
			.winBackground {
				position:fixed;
			    padding:0;
			    margin:0;
			    top:0;
			    left:0;
			    width: 100%;
			    height: 100%;
				background-color: #FF4500;
			}
		
		</style>

		<script type="text/javascript" src="scripts.js" >
		</script>
	</head>
	<body>
      <%
      	'users name - it will not change
		Dim name 
		name = Request.Form("nameValue") 

		'maximum guess a user can make
		Dim high 
		high = Request.Form("maxValue")	

		'the users progress in the game 
		'possible values: 0: maxGuess is out of range, 1: visit the guess page for the first time, 
		'2: guess is out of range, 3: guess is within range, update prompt, 4: win state
		Dim gameState 
		gameState = Request.Form("gameState") 
		if IsNumeric(gameState) then
			gameState = CInt(gameState)	
		end if

		'a variable used in setting up the game
		Dim startGame 
		startGame = Request.Form("startGame")
		if IsNumeric(startGame) then
			startGame = CInt(startGame)
		end if

		'a variable to safeguard against range checking before a guess has been submitted
		Dim rangeCheck 
		rangeCheck = Request.Form("rangeCheck") 
		if IsNumeric(rangeCheck) then
			rangeCheck = CInt(rangeCheck)	
		end if

		'minimum guess a user can make
		Dim low 
		low = Request.Form("minValue") 
		if IsNumeric(low) then
			low = CInt(low)	
		end if

		'winning number - guess must = win in order to win 
		Dim win
		win = Request.Form("winValue") 
		if IsNumeric(win) then
			win = CInt(win)	
		end if

		'guess the user makes
		Dim guess 
		guess = Request.Form("guessValue") 
		if IsNumeric(guess) then
			guess = CInt(guess)	
		end if

		'continue: the is only used when the users wins: used in setting gameState
		Dim continue 
		continue = Request.Form("continue") 
		if IsNumeric(continue) then
			continue = CInt(continue)	
		end if

		if IsNumeric(high) then
			high = CInt(high)	
			if (1 < high) then 	'server side validtion = checking the range
				gameState = 1	'green light to set up the game
			end if
		end if

		if gameState = 1 then	'high has passed server side validation
			'set up the game 
			if startGame = 0 then
				low = 1								'set initial low
				Randomize()							'seed
				win = CInt(Int((high * Rnd()) + 1))	'pick a number within guessing range
				startGame = 1	'this prevents the game from being set while the user is playing 
			end if 
		end if
		
		if rangeCheck = 1 then 
			if (guess < low) or (high < guess) then 'guess is out of range
				gameState = 2 						'out of range page
			else 
				gameState = 3						'within range page
			end if
		end if 

		'the following 3 if statements occur when the users guess is in range
		if (guess < win) and (gameState = 3) then
			low = (guess + 1)				'change low
			gameState = 3
		end if
		if (win < guess) and (gameState = 3) then
			high = (guess - 1)				'change high
			gameState = 3
		end if
		if (win = guess) and (gameState = 3) then			'win state
			gameState = 4 
		end if

		if (continue = 7) then 			'the is state when the user triggers a win state
			gameState = 5				'return the user to the max number page + hide error
		end if

		
		if (gameState = 1) then 	'user enters a guess for the first time
			rangeCheck = 1		'initialize guess checking
	  %>

	  	<form name="GameForm" action="GameEngine.asp" method="post" onsubmit="return validateGuess();">
	  		<!-- This is the enter your guess page : FOR THE FIRST TIME -->
			<div class="formWrapper">
				<h1>Hi-Lo Game!</h1>
				<div id="guessDiv" class="guessDiv">
					<p><%=name %>, please enter a guess</p>
					<p>Your guessing range is any value between <%=low %> and <%=high %></p>
					<input id="guessValue" type="text" name="guessValue" placeholder="Ex: 50" value="" />
					<input class="button" type="submit" value="Make this Guess"/>
					<br><br>
					<div id="guessError" class="errorColor">&nbsp;</div><br>
				</div>
			</div>
			<input type="hidden" id="nameValue" name="nameValue" value=<%=name %> />
			<input type="hidden" id="maxValue" name="maxValue" value=<%=high %> />
			<input type="hidden" id="startGame" name="startGame" value=<%=startGame %> />
			<input type="hidden" id="rangeCheck" name="rangeCheck" value=<%=rangeCheck %> />
			<input type="hidden" id="minValue" name="minValue" value=<%=low %> />
			<input type="hidden" id="winValue" name="winValue" value=<%=win %> />
		</form>
	  <%
	  	else if (gameState = 0) then	'high has failed validation
	  		startGame = 0		'keep setting this to 0 until high passes validation
	  %>
	  	<form name="GameForm" action="GameEngine.asp" method="POST" onsubmit="return validateMax();">
	  		<!-- This is the enter your max guess page and 1) failed range validation OR 2) played again -->
			<div class="formWrapper">
				<h1>Hi-Lo Game!</h1>
				<div id="maxDiv" class="maxDiv">
					<p><%=name %>, what is the maximum number you would like to guess?</p>
					<input id="maxValue" type="text" name="maxValue" placeholder="Ex: 50" />
					<input class="button" type="submit" value="Enter" />
					<br><br>
					<div id="maxError" class="errorSpecial">&nbsp;Error: The number you have chosen is out of range!</div>
				</div> <!-- delete if there is an error -->
			</div>
			<input type="hidden" id="nameValu e" name="nameValue" value=<%=name %> />
			<input type="hidden" id="startGame" name="startGame" value=<%=startGame %> />
			<input type="hidden" id="cleanForm" name="cleanForm" value=<%=cleanForm %> />
		</form>
	  <%
	  	else if (gameState = 2) then	'guess was out of range
	  %>
	  	<form name="GameForm" action="GameEngine.asp" method="post" onsubmit="return validateGuess();">
	  		<!-- This is the you entered a guess out of range page -->
			<div class="formWrapper">
				<h1>Hi-Lo Game!</h1>
				<div id="guessDiv" class="guessDiv">
					<p><%=name %>, please enter a guess</p>
					<p>Your guessing range is any value between <%=low %> and <%=high %></p>
					<input id="guessValue" type="text" name="guessValue" placeholder="Ex: 50" value="" />
					<input class="button" type="submit" value="Make this Guess"/>
					<br><br>
					<div id="guessError" class="errorColor">&nbsp;Error: The number you have chosen is out of range!</div><br>
				</div>
			</div>
			<input type="hidden" id="nameValue" name="nameValue" value=<%=name %> />
			<input type="hidden" id="maxValue" name="maxValue" value=<%=high %> />
			<input type="hidden" id="startGame" name="startGame" value=<%=startGame %> />
			<input type="hidden" id="rangeCheck" name="rangeCheck" value=<%=rangeCheck %> />
			<input type="hidden" id="minValue" name="minValue" value=<%=low %> />
			<input type="hidden" id="winValue" name="winValue" value=<%=win %> />
		</form>

	  <%
	  	else if (gameState = 3) then	'guess was in range
	  %>
	 	<form name="GameForm" action="GameEngine.asp" method="post" onsubmit="return validateGuess();">
	 		<!-- This is the enter your guess page : good job you guessed in range -->
			<div class="formWrapper">
				<h1>Hi-Lo Game</h1>
				<div id="guessDiv" class="guessDiv">
					<p><%=name %>, please enter a guess</p>
					<p>Your guessing range is any value between <%=low %> and <%=high %></p>
					<input id="guessValue" type="text" name="guessValue" placeholder="Ex: 50" value="" />
					<input class="button" type="submit" value="Make this Guess"/>
					<br><br>
					<div id="guessError" class="errorColor">&nbsp;</div><br>
				</div>
			</div>
			<input type="hidden" id="nameValue" name="nameValue" value=<%=name %> />
			<input type="hidden" id="maxValue" name="maxValue" value=<%=high %> />
			<input type="hidden" id="startGame" name="startGame" value=<%=startGame %> />
			<input type="hidden" id="rangeCheck" name="rangeCheck" value=<%=rangeCheck %> />
			<input type="hidden" id="minValue" name="minValue" value=<%=low %> />
			<input type="hidden" id="winValue" name="winValue" value=<%=win %> />
		</form>

	  <%
	  	else if (gameState = 4) then	'win state
	  		continue = 7				'unique number not avoid confusion
	  %>
	  	<form name="GameForm" action="GameEngine.asp" method="post">
	  		<!-- This is the you won page -->
			<div class="winBackground">
				<h1>Hi-Lo Game!</h1>
				<p>You win!! You guessed the number!!</p>
				<input class="buttonPA" type="submit" value="Play Again"/>
				<input type="hidden" id="nameValue" name="nameValue" value=<%=name %> />
				<input type="hidden" id="continue" name="continue" value=<%=continue %> />
		</form>
	  <%
	  	else if (gameState = 5) then	'high has failed validation
	  		startGame = 0		'keep setting this to 0 until high passes validation
	  %>
	  	<form name="GameForm" action="GameEngine.asp" method="POST" onsubmit="return validateMax();">
	  		<!-- This is the enter your max guess page -->
			<div class="formWrapper">
				<h1>Hi-Lo Game!</h1>
				<div id="maxDiv" class="maxDiv">
					<p><%=name %>, what is the maximum number you would like to guess?</p>
					<input id="maxValue" type="text" name="maxValue" placeholder="Ex: 50" />
					<input class="button" type="submit" value="Enter" />
					<br><br>
				<div id="maxError" class="errorSpecial">&nbsp;</div>
			</div>
			<input type="hidden" id="nameValue" name="nameValue" value=<%=name %> />
		</form>
	  <%
		end if
	  	end if
	  	end if
	  	end if
	  	end if
	  	end if
	  %>
	</body>
</hmtl>
