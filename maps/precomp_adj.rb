#  1  2  3  4
#  5  6  7  8
#  9 10 11 12
# 13 14 15 16
adjacency_map_1 = { 1 => [2,5],
                    2 => [1,3,6],
                    3 => [2,4,7],
                    4 => [3,8],
                    5 => [1,6,9],
                    6 => [2,5,7,10],
                    7 => [3,6,8,11],
                    8 => [4,7,12],
                    9 => [5,10,13],
                    10 =>[6,9,11,14],
                    11 =>[7,10,12,15],
                    12 =>[8,11,16],
                    13 =>[9,14],
                    14 =>[10,13,15],
                    15 =>[11,14,16],
                    16 =>[12,15]
                  }

#  1  2  3
#  4  5  6
#  7  8  9
adjacency_map_2 = { 1 => [2,4],
                    2 => [1,3,5],
                    3 => [2,6],
                    4 => [1,5,7],
                    5 => [2,4,6,8],
                    6 => [3,5,9],
                    7 => [4,8],
                    8 => [5,7,9],
                    9 => [6,8]
                  }
