************************************************************************
file with basedata            : md293_.bas
initial value random generator: 1022079191
************************************************************************
projects                      :  1
jobs (incl. supersource/sink ):  20
horizon                       :  149
RESOURCES
  - renewable                 :  2   R
  - nonrenewable              :  2   N
  - doubly constrained        :  0   D
************************************************************************
PROJECT INFORMATION:
pronr.  #jobs rel.date duedate tardcost  MPM-Time
    1     18      0       20        7       20
************************************************************************
PRECEDENCE RELATIONS:
jobnr.    #modes  #successors   successors
   1        1          3           2   3   4
   2        3          1           9
   3        3          3           5   7   8
   4        3          3           6  10  16
   5        3          2           9  19
   6        3          3          12  13  14
   7        3          3          12  16  18
   8        3          2          13  15
   9        3          1          15
  10        3          3          11  12  13
  11        3          2          14  15
  12        3          1          17
  13        3          1          17
  14        3          3          17  18  19
  15        3          1          18
  16        3          1          19
  17        3          1          20
  18        3          1          20
  19        3          1          20
  20        1          0        
************************************************************************
REQUESTS/DURATIONS:
jobnr. mode duration  R 1  R 2  N 1  N 2
------------------------------------------------------------------------
  1      1     0       0    0    0    0
  2      1     7       9    5    3    7
         2    10       7    3    3    7
         3    10       7    4    2    7
  3      1     4       8    9    6    7
         2     8       6    8    5    3
         3     8       8    9    5    1
  4      1     1       5    5   10    7
         2     6       4    4    8    6
         3    10       2    2    7    4
  5      1     1       6    5    5    3
         2     1       7    4    4    2
         3     3       4    4    3    2
  6      1     8      10    7    6    9
         2     9       7    5    6    9
         3    10       7    4    5    8
  7      1     2       6   10    8    7
         2     6       5    5    5    6
         3    10       5    5    4    3
  8      1     5       2    5    6    7
         2     8       2    4    2    6
         3     8       2    3    5    6
  9      1     4       3    9    5    6
         2     6       2    8    5    5
         3     7       1    8    4    5
 10      1     1       3    7    7    6
         2     4       2    6    7    6
         3     7       2    5    6    5
 11      1     4       5    8    2    8
         2     5       5    8    2    7
         3     9       5    7    2    7
 12      1     3       6    8    9    8
         2     3       6    6   10    9
         3     5       5    6    5    6
 13      1     9       7    3    9    7
         2     9       5    4    9    7
         3    10       4    3    7    7
 14      1     2       8    5    9    8
         2     3       5    3    7    7
         3     7       3    3    4    6
 15      1     2       3   10    6    7
         2     8       2    7    5    6
         3    10       2    5    4    6
 16      1     5       2    7    9    8
         2     6       2    6    9    6
         3     7       1    1    8    6
 17      1     2       6    1    7    6
         2     8       5    1    6    4
         3     9       4    1    3    3
 18      1     3       5    5   10    6
         2     9       2    2    8    6
         3     9       4    1    8    6
 19      1     1      10    9    4    8
         2     6       7    9    3    7
         3    10       7    8    2    3
 20      1     0       0    0    0    0
************************************************************************
RESOURCEAVAILABILITIES:
  R 1  R 2  N 1  N 2
   15   16   91  100
************************************************************************
