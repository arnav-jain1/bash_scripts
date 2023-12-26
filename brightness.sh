#!/bin/bash

#Min brightness allowed
min_brightness=50

brightness() {
  	#Get the current brightness
  	current_brightness=$(sudo brightnessctl | grep -oP 'Current brightness: \K\d+')
  
  	if [ "$#" -eq 0 ]; then
    	# No arguments, just print the current brightness
    	brightnessctl | grep 'Current brightness:'
  	elif [[ $1 =~ ^([+-]?)([0-9]+)%?$ ]]; then
    	# Argument is a relative or absolute change (e.g., +5, -5, 5, 5%), use regex to match the input and then store into vars
    	sign="${BASH_REMATCH[1]}"
    	value="${BASH_REMATCH[2]}"

		#Temp val to make sure brighness isnt too low
    	check=$(( value * 75 ))
		
		#If the sign is negative then
    	if [ "$sign" = "-" ]; then
		#Make sure brightness isnt too low, if it is then return otherwise set it 
      		new_brightness=$(( current_brightness - check ))
      		if [ "$new_brightness" -lt "$min_brightness" ]; then
        		echo "Cannot decrease brightness below $min_brightness."
        		return
      		fi
      		sudo brightnessctl set "$value%-" | grep 'Current brightness:'
    	elif [ "$sign" = "+" ]; then
		#If the sign is plus then just add it
      		sudo brightnessctl set "+$value%" | grep 'Current brightness:'
    	else
		#If there is no sign then just set it 
      		sudo brightnessctl set "$value%" | grep 'Current brightness:'
    	fi
  	else
    	echo "Invalid argument: $1"
    	return 1
  	fi
}

brightness_numeric() {
	#Same logic but absolute value instead of percent	  

  	current_brightness=$(sudo brightnessctl | grep -oP 'Current brightness: \K\d+')
  
  	if [ "$#" -eq 0 ]; then
    	# No arguments, just print the current brightness
    	brightnessctl | grep 'Current brightness:'
  	elif [[ $1 =~ ^([+-]?)([0-9]+)%?$ ]]; then
    	# Argument is a relative or absolute change (e.g., +5, -5, 5, 5%)
    	sign="${BASH_REMATCH[1]}"
    	value="${BASH_REMATCH[2]}"
    	if [ "$sign" = "-" ]; then
      		new_brightness=$(( current_brightness - value ))
      		if [ "$new_brightness" -lt "$min_brightness" ]; then
        		echo "Cannot decrease brightness below $min_brightness."
        		return
      		fi
      		sudo brightnessctl set "$value-" | grep 'Current brightness:'
    	elif [ "$sign" = "+" ]; then
      		sudo brightnessctl set "+$value" | grep 'Current brightness:'
    	else
		    #Make sure that the absolute brigtness is not lower than 50, not needed in percent because 1% is more than 50
      		if [ "$value" -lt "$min_brightness" ]; then
        		echo "Cannot set brightness below $min_brightness."
        		return
      		fi
      		sudo brightnessctl set "$value" | grep 'Current brightness:'
    	fi
  	else
    	echo "Invalid argument: $1"
    	return 1
  	fi
}



# Initialize variables for flags: numeric or max
n_flag=0
m_flag=0

# Parse the command-line options
while getopts "nm" opt; do
    case $opt in
        #If there is a n or m set it to 1
        n) n_flag=1 ;;
        m) m_flag=1 ;;
        #If there is anything else it is ignored
        *) usage ;;
    esac
done


#If the first arguement is -n then shift and call the numeric function, if it is -m then get the max brightness, otherwise call brightness function
if [ $n_flag -eq 1 ]; then
	shift
  	brightness_numeric "$@"
elif [ $m_flag -eq 1 ]; then
  	brightnessctl | grep 'Max brightness:'
else
  	brightness "$@"
fi