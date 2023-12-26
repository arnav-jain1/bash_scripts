#!/bin/bash

clean() {
    #Set the dir to the current
    local dir="."

    # Check if the first argument is a directory and if it is make the directory to the argument and shift the args
    if [ -d "$1" ]; then
        dir="$1"
        shift 
    fi

    #Excluded files are all of the args (after the shift)
    local excluded_files=("$@")

    # Removing files with the mentioned extensions (exe o out), except the excluded files
    for ext in exe o out; do
        #GO through each file
        for file in "$dir"/*.$ext; do
            local delete=true
            base_file=$(basename "$file")  # Extract just the file name
            #Go through the excluded files (args)
            for exclude in "${excluded_files[@]}"; do
                if [[ "$base_file" == "$exclude" ]]; then
                    #If the file is in the excluded files then set delete to false
                    delete=false
                    break
                fi
            done
            if [[ -f "$file" && "$delete" == true ]]; then
            #If delete is true then delete the file
                rm -f "$file"
            fi
        done
    done

    # Removing files with no extension except 'makefile', 'Makefile', and the excluded files (same logic)
    for file in $(find "$dir" -maxdepth 1 -type f ! -name "*.*" ! -name "makefile" ! -name "Makefile"); do
        base_file=$(basename "$file") 
        local delete=true
        for exclude in "${excluded_files[@]}"; do
            if [[ "$base_file" == "$exclude" ]]; then
                delete=false
                break
            fi
        done
        if [[ "$delete" == true ]]; then
            rm -f "$file"
        fi
    done
}

#Call the clean function with the same arguements
clean "$@"

