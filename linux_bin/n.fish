#!/usr/bin/env fish

# Parse arguments
set filename ""
set use_v false

for arg in $argv
    if test "$arg" = "-v"
        set use_v true
    else
        set filename "$arg"
    end
end

# Check if filename provided
if test -z "$filename"
    echo "Error: No filename provided" >&2
    echo "Usage: n.fish <filename> [-v]" >&2
    exit 1
end

# Get script directory
set script_dir (dirname (status --current-filename))

# Choose template
set template_name (test $use_v = true; and echo "template_v.cpp"; or echo "template.cpp")
set template_file "$script_dir/../templates/$template_name"
set target_file "$PWD/$filename.cpp"

# Check if template exists
if not test -f "$template_file"
    echo "Error: $template_name not found at $template_file" >&2
    exit 1
end

# Check if target file already exists
if test -f "$target_file"
    echo "Error: The file '$filename.cpp' already exists in $PWD" >&2
    exit 1
end

# Copy template to target
cp "$template_file" "$target_file"

echo "File '$filename.cpp' created successfully using $template_name in $PWD!"
