import sys

def binary_convert(nm):
    if nm > 32767:
        nm = 32767
    if nm < -32767:
        nm = -32767
    return nm

def merge_sort(arr):
    if len(arr) <= 1:
        return arr
    
    mid = len(arr) // 2
    left_half = merge_sort(arr[:mid])
    right_half = merge_sort(arr[mid:])
    
    return merge(left_half, right_half)

def merge(left, right):
    sorted_arr = []
    i = j = 0
    
    while i < len(left) and j < len(right):
        if left[i] < right[j]:
            sorted_arr.append(left[i])
            i += 1
        else:
            sorted_arr.append(right[j])
            j += 1
    
    sorted_arr.extend(left[i:])
    sorted_arr.extend(right[j:])
    
    return sorted_arr

def mediana(data):
    data_int = list(map(binary_convert, map(int, data.split())))
    sorted_data = merge_sort(data_int) 
    len_arr = len(sorted_data)

    if len_arr % 2 == 0:
        return (sorted_data[len_arr // 2 - 1] + sorted_data[len_arr // 2]) / 2
    else:
        return sorted_data[len_arr // 2]

def average_value(data):
    data_int = list(map(binary_convert, map(int, data.split())))
    sorted_data = merge_sort(data_int)
    return sum(sorted_data) // len(sorted_data)

def analz_file(filename):
    with open(filename, "r") as data:
        return data.read()

if __name__ == "__main__":
    filename = sys.argv[1]
    file_data = analz_file(filename)
    med = mediana(file_data)
    print(med)
    mid_ar = average_value(file_data)
    print(mid_ar)
