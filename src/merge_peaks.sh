#!/usr/bin/env bash

# -----------------------------
# common_peaks.sh: Find common peaks
# -----------------------------

# 显示帮助信息
show_help() {
    echo "Usage: $0 -i <input_files> -o <output_file> [-n <N>]"
    echo
    echo "Options:"
    echo "  -i    Input BED files (2 or more, separated by space, required)"
    echo "  -o    Output BED file (required)"
    echo "  -n    Minimum number of files that must overlap (optional, default = number of input files, i.e. strict intersection)"
    echo "  -h    Show this help message"
}

# 默认参数
N=0
input_files=()
out_file=""

# 解析参数
while [[ $# -gt 0 ]]; do
    case "$1" in
        -i)
            shift
            while [[ $# -gt 0 && ! "$1" =~ ^- ]]; do
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
        -h)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# 参数检查
if [[ ${#input_files[@]} -lt 2 || -z "$out_file" ]]; then
    echo "Error: You must provide at least 2 input files and one output file."
    show_help
    exit 1
fi

# 如果没指定 -n，默认 = 输入文件数（严格交集）
if [[ $N -eq 0 ]]; then
    N=${#input_files[@]}
fi

# 计算
echo "Finding regions present in at least $N out of ${#input_files[@]} files..."
bedtools multiinter -i "${input_files[@]}" \
    | awk -v n=$N '$4 >= n {print $0}' \
    > "$out_file"

echo "Result saved in $out_file"
