module dreamcast.pvr.fog;

extern(C):
nothrow:
@nogc:

/**
   This table is used by the pvr_fog.c module to scale values for the PVR's
   fog table.  It can be used directly with each value multiplied by 255
   to make perspectively correct table values for linear fog. The table does
   not include the value of 1.0 which represents full visual occlusion.
 */
__gshared const float[] inverseWDepth = [
    0.94118, 0.88889, 0.84211, 0.80000, 0.76190, 0.72727, 0.69565, 0.66667,
    0.64000, 0.61538, 0.59259, 0.57143, 0.55172, 0.53333, 0.51613, 0.50000,
    0.47059, 0.44444, 0.42105, 0.40000, 0.38095, 0.36364, 0.34783, 0.33333,
    0.32000, 0.30769, 0.29630, 0.28571, 0.27586, 0.26667, 0.25806, 0.25000,
    0.23529, 0.22222, 0.21053, 0.20000, 0.19048, 0.18182, 0.17391, 0.16667,
    0.16000, 0.15385, 0.14815, 0.14286, 0.13793, 0.13333, 0.12903, 0.12500,
    0.11765, 0.11111, 0.10526, 0.10000, 0.09524, 0.09091, 0.08696, 0.08333,
    0.08000, 0.07692, 0.07407, 0.07143, 0.06897, 0.06667, 0.06452, 0.06250,
    0.05882, 0.05556, 0.05263, 0.05000, 0.04762, 0.04545, 0.04348, 0.04167,
    0.04000, 0.03846, 0.03704, 0.03571, 0.03448, 0.03333, 0.03226, 0.03125,
    0.02941, 0.02778, 0.02632, 0.02500, 0.02381, 0.02273, 0.02174, 0.02083,
    0.02000, 0.01923, 0.01852, 0.01786, 0.01724, 0.01667, 0.01613, 0.01562,
    0.01471, 0.01389, 0.01316, 0.01250, 0.01190, 0.01136, 0.01087, 0.01042,
    0.01000, 0.00962, 0.00926, 0.00893, 0.00862, 0.00833, 0.00806, 0.00781,
    0.00735, 0.00694, 0.00658, 0.00625, 0.00595, 0.00568, 0.00543, 0.00521,
    0.00500, 0.00481, 0.00463, 0.00446, 0.00431, 0.00417, 0.00403, 0.00391,
];

/**
    This is essentially the same table as above except each value has been
    multiplied by 259.999999. This table is used by the EXP and EXP2
    fog functions in pvr_fog.c.  It just saves us one multiplcation per table
    entry.
*/
__gshared const float[] inverseWDepth260 = [
    244.706, 231.111, 218.947, 208.000, 198.095, 189.091, 180.870, 173.333,
    166.400, 160.000, 154.074, 148.571, 143.448, 138.667, 134.194, 130.000,
    122.353, 115.556, 109.474, 104.000, 99.048, 94.545, 90.435, 86.667,
    83.200, 80.000, 77.037, 74.286, 71.724, 69.333, 67.097, 65.000,
    61.176, 57.778, 54.737, 52.000, 49.524, 47.273, 45.217, 43.333,
    41.600, 40.000, 38.519, 37.143, 35.862, 34.667, 33.548, 32.500,
    30.588, 28.889, 27.368, 26.000, 24.762, 23.636, 22.609, 21.667,
    20.800, 20.000, 19.259, 18.571, 17.931, 17.333, 16.774, 16.250,
    15.294, 14.444, 13.684, 13.000, 12.381, 11.818, 11.304, 10.833,
    10.400, 10.000, 9.630, 9.286, 8.966, 8.667, 8.387, 8.125,
    7.647, 7.222, 6.842, 6.500, 6.190, 5.909, 5.652, 5.417,
    5.200, 5.000, 4.815, 4.643, 4.483, 4.333, 4.194, 4.062,
    3.824, 3.611, 3.421, 3.250, 3.095, 2.955, 2.826, 2.708,
    2.600, 2.500, 2.407, 2.321, 2.241, 2.167, 2.097, 2.031,
    1.912, 1.806, 1.711, 1.625, 1.548, 1.477, 1.413, 1.354,
    1.300, 1.250, 1.204, 1.161, 1.121, 1.083, 1.048, 1.016,
];

/** 
    lookup table for the fast neg_exp function 
*/
__gshared const float[] expTable = [
    1.00000000,  0.96169060,  0.92484879,  0.88941842,
    0.85534531,  0.82257754,  0.79106510,  0.76075989,
    0.73161560,  0.70358789,  0.67663383,  0.65071243,
    0.62578398,  0.60181057,  0.57875562,  0.55658382,
    0.53526145,  0.51475590,  0.49503589,  0.47607136,
    0.45783335,  0.44029403,  0.42342663,  0.40720543,
    0.39160562,  0.37660345,  0.36217600,  0.34830126,
    0.33495805,  0.32212600,  0.30978554,  0.29791784,
    0.28650481,  0.27552897,  0.26497361,  0.25482264,
    0.24506053,  0.23567241,  0.22664395,  0.21796136,
    0.20961139,  0.20158130,  0.19385885,  0.18643223,
    0.17929012,  0.17242162,  0.16581626,  0.15946393,
    0.15335497,  0.14748003,  0.14183016,  0.13639674,
    0.13117145,  0.12614636,  0.12131377,  0.11666631,
    0.11219689,  0.10789870,  0.10376516,  0.09978998,
    0.09596708,  0.09229065,  0.08875505,  0.08535489,
    0.08208500,  0.07894037,  0.07591622,  0.07300791,
    0.07021102,  0.06752128,  0.06493458,  0.06244697,
    0.06005467,  0.05775401,  0.05554149,  0.05341373,
    0.05136748,  0.04939962,  0.04750715,  0.04568718,
    0.04393693,  0.04225374,  0.04063502,  0.03907832,
    0.03758125,  0.03614154,  0.03475698,  0.03342546,
    0.03214495,  0.03091349,  0.02972922,  0.02859031,
    0.02749503,  0.02644171,  0.02542875,  0.02445459,
    0.02351775,  0.02261679,  0.02175036,  0.02091712,
    0.02011579,  0.01934517,  0.01860407,  0.01789136,
    0.01720595,  0.01654680,  0.01591290,  0.01530329,
    0.01471703,  0.01415323,  0.01361103,  0.01308960,
    0.01258814,  0.01210590,  0.01164213,  0.01119613,
    0.01076721,  0.01035472,  0.00995804,  0.00957655,
    0.00920968,  0.00885686,  0.00851756,  0.00819126,
    0.00787746,  0.00757568,  0.00728546,  0.00700636,
    0.00673795,  0.00647982,  0.00623158,  0.00599285,
    0.00576327,  0.00554248,  0.00533015,  0.00512596,
    0.00492959,  0.00474074,  0.00455912,  0.00438447,
    0.00421650,  0.00405497,  0.00389962,  0.00375023,
    0.00360656,  0.00346840,  0.00333553,  0.00320774,
    0.00308486,  0.00296668,  0.00285303,  0.00274373,
    0.00263862,  0.00253753,  0.00244032,  0.00234684,
    0.00225693,  0.00217047,  0.00208732,  0.00200735,
    0.00193045,  0.00185650,  0.00178538,  0.00171698,
    0.00165120,  0.00158795,  0.00152711,  0.00146861,
    0.00141235,  0.00135824,  0.00130621,  0.00125617,
    0.00120805,  0.00116177,  0.00111726,  0.00107446,
    0.00103330,  0.00099371,  0.00095564,  0.00091903,
    0.00088383,  0.00084997,  0.00081741,  0.00078609,
    0.00075598,  0.00072702,  0.00069916,  0.00067238,
    0.00064662,  0.00062185,  0.00059803,  0.00057512,
    0.00055308,  0.00053190,  0.00051152,  0.00049192,
    0.00047308,  0.00045495,  0.00043753,  0.00042076,
    0.00040465,  0.00038914,  0.00037424,  0.00035990,
    0.00034611,  0.00033285,  0.00032010,  0.00030784,
    0.00029604,  0.00028470,  0.00027380,  0.00026331,
    0.00025322,  0.00024352,  0.00023419,  0.00022522,
    0.00021659,  0.00020829,  0.00020031,  0.00019264,
    0.00018526,  0.00017816,  0.00017134,  0.00016477,
    0.00015846,  0.00015239,  0.00014655,  0.00014094,
    0.00013554,  0.00013035,  0.00012535,  0.00012055,
    0.00011593,  0.00011149,  0.00010722,  0.00010311,
    0.00009916,  0.00009536,  0.00009171,  0.00008820,
    0.00008482,  0.00008157,  0.00007844,  0.00007544,
    0.00007255,  0.00006977,  0.00006710,  0.00006453,
    0.00006205,  0.00005968,  0.00005739,  0.00005519,
    0.00005308,  0.00005104,  0.00004909,  0.00004721,
];