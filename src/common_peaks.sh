#!/usr/bin/env bash

# -----------------------------
# peak common: find common peaks
# -----------------------------

show_help() {
    echo "Usage: peak common -i <file1.bed> <file2.bed> ... -o <output.bed> [-n N]"
    echo
    echo "Arguments:"
    echo "  -i    Input BED files (at least 2)"
    echo "  -o    Output BED file (required)"
    echo "  -n    Minimum number of files that must overlap (optional)"
    echo "  -h    Show this help message"
    exit 0
}

N=0
out_file=""
input_files=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        -i)
            shift
            while [[ $# -gt 0 && "$1" != -* ]]; do
                input_files+=("$1")
                shift
            done
            ;;
        -o)
            out_file="$2"
            shift 2
            ;;
        -n)
            N="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            ;;
    esac
done

# 参数检查
if [[ -z "$out_file" || ${#input_files[@]} -lt 2 ]]; then
    echo "Error: at least 2 input files and an output file are required."
    show_help
fi

# 运行逻辑
if [[ $N -gt 0 ]]; then
    echo "? Finding regions present in at least $N files..."
    bedtools multiinter -i "${input_files[@]}" \
        | awk -v n=$N '$4 >= n {print $0}' \
        > "$out_file"
else
    echo "Finding strict intersection of all files..."
    cp "${input_files[0]}" tmp_common.bed
    for ((i=1; i<${#input_files[@]}; i++)); do
        bedtools intersect -a tmp_common.bed -b "${input_files[i]}" > tmp_out.bed
        mv tmp_out.bed tmp_common.bed
    done
    mv tmp_common.bed "$out_file"
fi

echo "Result written to $out_file"
