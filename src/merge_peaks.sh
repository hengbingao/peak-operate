#!/usr/bin/env bash

# -----------------------------
# common_peaks.sh: Find common peaks
# -----------------------------

# ��ʾ������Ϣ
show_help() {
    echo "Usage: $0 -i <input_files> -o <output_file> [-n <N>]"
    echo
    echo "Options:"
    echo "  -i    Input BED files (2 or more, separated by space, required)"
    echo "  -o    Output BED file (required)"
    echo "  -n    Minimum number of files that must overlap (optional, default = number of input files, i.e. strict intersection)"
    echo "  -h    Show this help message"
}

# Ĭ�ϲ���
N=0
input_files=()
out_file=""

# ��������
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

# �������
if [[ ${#input_files[@]} -lt 2 || -z "$out_file" ]]; then
    echo "Error: You must provide at least 2 input files and one output file."
    show_help
    exit 1
fi

# ���ûָ�� -n��Ĭ�� = �����ļ������ϸ񽻼���
if [[ $N -eq 0 ]]; then
    N=${#input_files[@]}
fi

# ����
echo "Finding regions present in at least $N out of ${#input_files[@]} files..."
bedtools multiinter -i "${input_files[@]}" \
    | awk -v n=$N '$4 >= n {print $0}' \
    > "$out_file"

echo "Result saved in $out_file"
