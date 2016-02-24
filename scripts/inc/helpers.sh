# Grab a numbered field from python prettytable output
# Fields are numbered starting with 1
# Reverse syntax is supported: -1 is the last field, -2 is second to last, etc.
# get_field field-number
function get_field {
    local data field
    while read data; do
        if [ "$1" -lt 0 ]; then
            field="(\$(NF$1))"
        else
            field="\$$(($1 + 1))"
        fi
        echo "$data" | awk -F'[ \t]*\\|[ \t]*' "{print $field}"
    done
}

# Get list of sections from an INI file
# iniget_sections config-file
function iniget_sections {
    local xtrace
    xtrace=$(set +o | grep xtrace)
    set +o xtrace
    local file=$1

    echo $(sed -ne "s/^\[\(.*\)\]/\1/p" "$file")
    $xtrace
}

# Get an option from an INI file
# iniget config-file section option
function iniget {
    local xtrace
    xtrace=$(set +o | grep xtrace)
    set +o xtrace
    local file=$1
    local section=$2
    local option=$3
    local line

    line=$(sed -ne "/^\[$section\]/,/^\[.*\]/ { /^$option[ \t]*=/ p; }" "$file")
    echo ${line#*=}
    $xtrace
}
