import sys

def binary_convert():
    pass

def mediana(data):
    data_int = list(map(int, data.split()))
    len_arr = len(data_int)

    if len_arr % 2 == 0:
        return (data_int[len_arr // 2 - 1] + data_int[len_arr // 2]) / 2
    else:
        return data_int[len_arr // 2]

def average_value(data):
    pass

def analz_file(filename):
    with open(filename, "r") as data:
        return data.read()

if __name__ == "__main__":
    filename = sys.argv[1]
    file_data = analz_file(filename)
    med = mediana(file_data)
    print(med)
