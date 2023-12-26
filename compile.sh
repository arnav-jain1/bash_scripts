#!/bin/bash

# Initialize variables for flags: assembly, time, run, and memory check flags respectively
a_flag=0
t_flag=0
r_flag=0
m_flag=0

# Parse the command-line options
while getopts "atrm" opt; do
    case $opt in
        #If there is an a, t, m, or r it is set to 1
        a) a_flag=1 ;;
        t) t_flag=1 ;;
        r) r_flag=1 ;;
        m) m_flag=1 ;;
        #If there is anything else it is ignored
        *) usage ;;
    esac
done

#Shift the arguments
shift $((OPTIND - 1))


# Function to compile and execute C++ files
compile_cpp() {
    echo "Compiling C++ file: $1"
    
    #Gets the basename of the file without the extension
    base_name=$(basename "$1")
    base_name="${base_name%.cpp}"
    output_file="${base_name}"

    #If the a (assembly) flag is enabled then assemble
    if [ $a_flag -eq 1 ]; then 
        echo "g++ -Wall -S -masm=intel -g \"$1\" -o \"$output_file.s\""

        #T variable for timing
        T=$(date +%s%N)
        g++ -Wall -S -masm=intel -g "$1" -o "$output_file.s"
        T=$(echo "scale=3; ($(date +%s%N) - $T) / 1000000000" | bc)

        #If Time flag is enabled then print the time
        if [ $t_flag -eq 1 ]; then 
            echo "Assembly took ${T} seconds!"
        fi

    fi


    # Compiles the file with the address sanitizer enabled, all warnings enabled, debug symbols enabled, and memory leak detection enabled 
    #Same logic for T flag as before
    echo "g++ -Wall -fsanitize=address -fno-omit-frame-pointer -g \"$1\" -o \"$output_file\""
    T=$(date +%s%N)
    g++ -Wall -fsanitize=address -fno-omit-frame-pointer -g "$1" -o "$output_file"
    T=$(echo "scale=3; ($(date +%s%N) - $T) / 1000000000" | bc)
    

    if [ $t_flag -eq 1 ]; then 
        echo "Compilation took ${T} seconds!"
    fi

    # Checks if the compilation was successful
    if [ $? -eq 0 ]; then
        echo "Compilation successful."
        # If the r flag is enabled then run it
        if [ $r_flag -eq 1 ]; then 
            echo -e "Running $output_file \n\n\n"
            ./"$output_file"
                # Run the program with Valgrind if flag is enabled and remove the fluff
                if [ $m_flag -eq 1 ]; then
                    echo "Running memory check with Valgrind..."
                    valgrind --leak-check=full --show-leak-kinds=all ./"$output_file" 2>&1 | grep -E "ERROR SUMMARY"
                fi
            fi
    else
        echo "Compilation failed."
    fi
}


# Function to compile and execute C files
compile_c() {
    echo "Compiling C file: $1"

    # Gets the basename of the file without the extension
    base_name=$(basename "$1")
    base_name="${base_name%.c}"
    output_file="${base_name}"

    #If the a (assembly) flag is enabled then assemble
    if [ $a_flag -eq 1 ]; then 
        echo "gcc -Wall -S -masm=intel -g \"$1\" -o \"$output_file.s\" -lm"

        T=$(date +%s%N)
        gcc -Wall -S -masm=intel -g "$1" -o "$output_file.s" -lm
        T=$(echo "scale=3; ($(date +%s%N) - $T) / 1000000000" | bc)

        # If the time flag is enabled then print the time
        if [ $t_flag -eq 1 ]; then 
            echo "Assembly took ${T} seconds!"
        fi

    fi

    # Compiles the file with all warnings enabled, debug symbols enabled, and linking to the math library
    echo "gcc -Wall -g \"$1\" -o \"$output_file\" -lm"
    T=$(date +%s%N)
    gcc -Wall -g "$1" -o "$output_file" -lm
    T=$(echo "scale=3; ($(date +%s%N) - $T) / 1000000000" | bc)
    
    #If the t flag is enabled then print the time
    if [ $t_flag -eq 1 ]; then 
        echo "Compilation took ${T} seconds!"
    fi

    # Checks if the compilation was successful, and if it was, runs the executable
    if [ $? -eq 0 ]; then
        echo "Compilation successful."
        #If run flag is enabled then run it
        if [ $r_flag -eq 1 ]; then 
            echo -e "Running $output_file \n\n\n"
            ./"$output_file"
            # Run the program with Valgrind if flag enabled
            if [ $m_flag -eq 1 ]; then
                echo "Running memory check with Valgrind..."
                valgrind --leak-check=full --show-leak-kinds=all ./"$output_file" 2>&1 | grep -E "ERROR SUMMARY"
            fi
        fi 
    else
        echo "Compilation failed."
    fi
}


# Function to compile all C or C++ files in a directory
compile_directory() {
    
    #Cd into the directory specified as an argument
    cd "$1"
    
    # Check if there are any C or C++ files in the directory
    cpp_files=$(ls *.cpp 2> /dev/null | wc -l)
    c_files=$(ls *.c 2> /dev/null | wc -l)

    # If there are C++ files, compile them, otherwise, if there are C files, compile them
    if [ "$cpp_files" != "0" ]; then
        echo "Compiling all C++ files..."
        
        #If the a (assembly) flag is enabled then assemble
        if [ $a_flag -eq 1 ]; then 
            echo "g++ -Wall -S -masm=intel -g *.cpp"

            T=$(date +%s%N)
            g++ -Wall -S -masm=intel -g *.cpp
            T=$(echo "scale=3; ($(date +%s%N) - $T) / 1000000000" | bc)

            # If the time flag is enabled then print the time
            if [ $t_flag -eq 1 ]; then 
                echo "Assembly took ${T} seconds!"
            fi

        fi


        # Compiles all C++ files with the address sanitizer enabled, all warnings enabled, debug symbols enabled, and memory leak detection enabled
        echo "g++ -Wall -fsanitize=address -fno-omit-frame-pointer -g *.cpp -o main"
        T=$(date +%s%N)
        g++ -Wall -fsanitize=address -fno-omit-frame-pointer -g *.cpp -o main
        T=$(echo "scale=3; ($(date +%s%N) - $T) / 1000000000" | bc)

        #If the t flag is enabled then print the time
        if [ $t_flag -eq 1 ]; then 
            echo "Compilation took ${T} seconds!"
        fi


        if [ $? -eq 0 ]; then
            # If the compilation was successful, run the executable
            echo "Compilation successful."
            if [ $r_flag -eq 1 ]; then 
                echo -e "Running main \n\n\n"
                ./main
                # Run the program with Valgrind if flag enabled (and remove the fluff)
                if [ $m_flag -eq 1 ]; then
                    echo "Running memory check with Valgrind..."
                    valgrind --leak-check=full --show-leak-kinds=all ./main  2>&1 | grep -E "ERROR SUMMARY"
                fi
            fi
        else
            echo "Compilation failed."
        fi
    
#Compile C files
    elif [ "$c_files" != "0" ]; then
        echo "Compiling all C files..."
        

        #If the a (assembly) flag is enabled then assemble
        if [ $a_flag -eq 1 ]; then 
            echo "gcc -Wall -S -masm=intel -g *.c -lm"

            T=$(date +%s%N)
            gcc -Wall -S -masm=intel -g *.c -lm
            T=$(echo "scale=3; ($(date +%s%N) - $T) / 1000000000" | bc)

            # If the time flag is enabled then print the time
            if [ $t_flag -eq 1 ]; then 
                echo "Assembly took ${T} seconds!"
            fi

        fi


        # Compiles all C files with all warnings enabled, debug symbols enabled, and linking to the math library
        echo "gcc -Wall -g *.c -o main -lm"
        T=$(date +%s%N)
        gcc -Wall -g *.c -o main -lm
        T=$(echo "scale=3; ($(date +%s%N) - $T) / 1000000000" | bc)

        #If the t flag is enabled then print the time
        if [ $t_flag -eq 1 ]; then 
            echo "Compilation took ${T} seconds!"
        fi


        
        # If the compilation was successful, run the executable
        if [ $? -eq 0 ]; then
            echo "Compilation successful."
            if [ $r_flag -eq 1 ]; then 
                echo -e "Running main \n\n\n"
                ./main
                # Run the program with Valgrind
                if [ $m_flag -eq 1 ]; then
                    echo "Running memory check with Valgrind..."
                    valgrind --leak-check=full --show-leak-kinds=all ./main 2>&1 | grep -E "ERROR SUMMARY"
                fi
            fi
        else
            echo "Compilation failed."
        fi
    else
        # If there are no C or C++ files in the directory, print an error message
        echo "No C or C++ files found in the directory $1."
    fi
}








# Check if a specific file or directory is specified as an argument
if [ "$#" -eq 1 ]; then
    path="$1"
    
    # Check if the specified path is a directory or a file
    if [ -d "$path" ]; then
        # If it is a directory, call the compile_directory function
        compile_directory "$path"
    elif [ -f "$path" ]; then
        # If it is a file, check if it is a C or C++ file, and call the appropriate function
        if [[ $path == *.cpp ]]; then
            compile_cpp "$path"
        elif [[ $path == *.c ]]; then
            compile_c "$path"
        else
            # If it is neither a C or C++ file, print an error message
            echo "Unknown file type specified. Please specify a C or C++ file or directory."
        fi
    else
        # If the specified path does not exist, print an error message
        echo "Specified path $path does not exist."
    fi
else
    # If no arguments are specified, call the compile_directory function on the current directory
    compile_directory "."
fi



#Check for memory flag without run flag
if [[ $r_flag -eq 0 && $m_flag -eq 1 ]]; then
    echo "Memory flag without run flag, memory check not ran."
fi