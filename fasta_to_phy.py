#!/usr/bin/python

import sys

def build_destination_file_path(origin_file_full_path):
    return origin_file_full_path.replace('.fas', '.phy')

def find_number_of_samples_and_bases(file):
    # Reads the second line
    line = file.readline()
    line = file.readline()
    # -1 because of trailing character
    number_of_bases = len(line) - 1
    # Put the pointer on the beginning of the file
    file.seek(0,0)
    number_of_samples = sum(1 for line in file.readlines()) // 2
    #num_lines = sum(1 for line in open('myfile.txt'))

    return number_of_samples, number_of_bases

def build_argument_with_spaces(arg_list):
    argument = arg_list[0]
    if len(arg_list) > 1:
        for word in arg_list[1:]:
            argument += ' {}'.format(word)

    return argument

if len(sys.argv) <= 1:
    print('File\'s full path has not been provided.')
else:
    origin_file_full_path = build_argument_with_spaces(sys.argv[1:])
    with open(origin_file_full_path) as origin_file:
        print('Reading from {}'.format(origin_file_full_path))
        number_of_samples, number_of_bases = find_number_of_samples_and_bases(origin_file)
        origin_file.seek(0,0)
        destination_file_full_path = build_destination_file_path(origin_file_full_path)
        with open(destination_file_full_path, 'w') as destination_file:
            print('Writing on {}'.format(destination_file_full_path))
            destination_file.write('{} {}'.format(number_of_samples, number_of_bases))
            destination_file.write('\n')
            destination_file.write('\n')
            for line in origin_file:
                line = line.replace('>', '')
                destination_file.write(line)
