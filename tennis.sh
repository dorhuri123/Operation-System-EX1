#!/bin/bash
#Dor Huri 209409218

start_middle_line=" |       |       O       |       | "
area1_p1=" |       |   O   #       |       | "
area2_p1=" |   O   |       #       |       | "
area3_p1="O|       |       #       |       | "
area1_p2=" |       |       #   O   |       | "
area2_p2=" |       |       #       |   O   | "
area3_p2=" |       |       #       |       |O"
player1_score=50
player2_score=50
flag=0
game_position=0 

#function for printing the game board with changing middle row
print_game_board() {
	echo " Player 1: ${player1_score}         Player 2: ${player2_score} "
	echo " --------------------------------- "
	echo " |       |       #       |       | "
	echo " |       |       #       |       | "
	echo "$1"
	echo " |       |       #       |       | "
	echo " |       |       #       |       | "
	echo " --------------------------------- "
}

#function for choosing numbers for player and checking thir choice is valid
choose_num(){
	while true; do
		echo "PLAYER 1 PICK A NUMBER: "
		read -s player1_num
		res=$[$player1_score - $player1_num]
		#checking if input is a number and is less or equle to the player score
		if [[ $player1_num =~ ^[0-9]+$ && $res -ge 0 ]] ;
		then
			#updating player score and exiting loop
			player1_score=$[$player1_score - $player1_num]
			break
		else
			echo "NOT A VALID MOVE !"
		fi
	done
	while true; do
	echo "PLAYER 2 PICK A NUMBER: "
	read -s player2_num
	res=$[$player2_score - $player2_num]
	#checking if input is a number and is less or equle to the player score
	if [[ $player2_num =~ ^[0-9]+$ && $res -ge 0 ]];
	then
		#updating player score and exiting loop
		player2_score=$[$player2_score - $player2_num]
		break
	else
		echo "NOT A VALID MOVE !"
	fi
	done
	#if player1 win the turn win_turn get 1
	if [[ $player1_num -gt $player2_num ]];
	then
		win_turn=1
	#if player2 win the turn win_turn get -1
	elif [[ $player2_num -gt $player1_num ]];
	then
		win_turn=-1
	#in case of a drew in the turn win_turn get 0
	else
		win_turn=0
	fi
}
who_win(){
	#checking if the ball is out for player 2
	if [[ $game_position -eq 3 ]];
	then
		flag=1
	#checking if the ball is out for player 1
	elif [[ $game_position -eq -3 ]];
	then
		flag=-1
	#checking in case both player score is 0
	elif [[ $player1_score -eq 0 && $player2_score -eq 0 ]];
	then
		#in case ball is still in the middle flag get 2 indacting a drew
		if [[ $game_position -eq 0 ]];
		then
			flag=2
		#in case the ball postion is greater then 0 flag get 1
		elif [[  $game_position -gt 0 ]];
		then
			flag=1
		#in case the ball postion is less then 0 flag get -1
		else
			flag=-1
		fi
	#checking if player1 score is 0 and player2 is not 0
	elif [[ $player1_score -eq 0 && $player2_score -ne 0 ]];
	then
		flag=-1
	#checking if player2 score is 0 and player1 is not 0
	elif [[ $player1_score -ne 0 && $player2_score -eq 0 ]];
	then
		flag=1
	fi
	#if flag is 1 player 1 win
	if [[ $flag -eq 1 ]];
	then
		echo "PLAYER 1 WINS !"
	#if flag is -1 player 2 win
	elif [[ $flag -eq -1 ]];
	then
		echo "PLAYER 2 WINS !"
	#if flag is 2 its a drew
	elif [[ $flag -eq 2 ]];
	then
		echo "IT'S A DRAW !"
	fi
}


#starting with default board
print_game_board "$start_middle_line"
while [ $flag -eq 0 ]
do
#players choosing numbers
choose_num
#setting the ball to the correct position on screen
game_position=$[$game_position + $win_turn]
#in case ball in the middle
if [[ $game_position -eq 0 ]];
then
	game_position=$win_turn
fi
#print the middle row according to game_position
case $game_position in
	1)
		print_game_board "$area1_p2" ;;
	2)
		print_game_board "$area2_p2";;
	3)
		print_game_board "$area3_p2";;
	-1)
		print_game_board "$area1_p1" ;;
	-2)
		print_game_board "$area2_p1";;
	-3)
		print_game_board "$area3_p1";;
	 0)
	        print_game_board "$start_middle_line"	
esac
echo -e "       Player 1 played: ${player1_num}\n       Player 2 played: ${player2_num}\n\n"
#checking if there is winner
who_win
done
