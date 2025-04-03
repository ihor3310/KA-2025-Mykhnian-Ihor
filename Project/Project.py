import sys

def bubble_sort(arr):
    n = len(arr)
    for i in range(n):
        for j in range(0, n - i - 1):
            if arr[j] > arr[j + 1]:
                arr[j], arr[j + 1] = arr[j + 1], arr[j] 
    return arr

def mediana(data):
    data_int = list(map(int, data.split()))
    sorted_data = bubble_sort(data_int) 
    len_arr = len(sorted_data)

    if len_arr % 2 == 0:
        return (sorted_data[len_arr // 2 - 1] + sorted_data[len_arr // 2]) / 2
    else:
        return sorted_data[len_arr // 2]

def average_value(data):
    data_int = list(map(int, data.split()))
    sorted_data = bubble_sort(data_int)
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
