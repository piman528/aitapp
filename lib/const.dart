const Map<DayOfWeek, String> dayOfWeekToString = {
  DayOfWeek.monday: '月',
  DayOfWeek.tuesday: '火',
  DayOfWeek.wednesday: '水',
  DayOfWeek.thurstay: '木',
  DayOfWeek.friday: '金',
  DayOfWeek.saturday: '土',
  DayOfWeek.sunday: '月',
};
const Map<DayOfWeek, int> dayOfWeekToInt = {
  DayOfWeek.monday: 1,
  DayOfWeek.tuesday: 2,
  DayOfWeek.wednesday: 3,
  DayOfWeek.thurstay: 4,
  DayOfWeek.friday: 5,
  DayOfWeek.saturday: 6,
  DayOfWeek.sunday: 7,
};

enum DayOfWeek {
  sunday,
  monday,
  tuesday,
  wednesday,
  thurstay,
  friday,
  saturday
}

const List<DayOfWeek> activeWeek = [
  DayOfWeek.monday,
  DayOfWeek.tuesday,
  DayOfWeek.wednesday,
  DayOfWeek.thurstay,
  DayOfWeek.friday,
];

const List<List<String>> classPeriods = [
  [
    '09:00',
    '10:30',
  ],
  [
    '10:40',
    '12:10',
  ],
  [
    '13:00',
    '14:30',
  ],
  [
    '14:40',
    '16:10',
  ],
  [
    '16:20',
    '17:50',
  ],
  [
    '18:00',
    '19:30',
  ],
];

const Map<String, Map<String, Map<String, Map<int, List<int>>>>> daiya = {
  'bus': {
    'toAIT': {
      'A': {
        8: [00, 05, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55],
        9: [00, 05, 10, 15, 20, 25, 30, 35, 40, 50, 55],
        10: [00, 05, 10, 15, 20, 25, 30, 35, 45, 55],
        11: [05, 15, 25, 35, 45, 55],
        12: [05, 15, 25, 35, 45, 55],
        13: [05, 20, 35, 50],
        14: [05, 15, 25, 35, 45, 55],
        15: [05, 15, 30, 45],
        16: [00, 15, 30, 45],
        17: [00, 10, 25, 40],
        18: [00, 15, 45],
        19: [00, 15, 30, 45],
        20: [00, 30],
        21: [00],
      },
      'B': {
        8: [00, 10, 20, 35, 45],
        9: [00, 05, 25, 35, 50],
        10: [00, 10, 30, 55],
        11: [00, 25, 50],
        12: [25],
        13: [35],
        14: [05, 35],
        15: [05, 35],
        16: [05, 45],
        17: [10, 45],
        18: [05, 35],
        19: [35],
        20: [25],
        21: [05],
      },
      'C': {
        8: [10, 35],
        9: [00, 25, 50],
        10: [10, 55],
        11: [25, 50],
        12: [25],
        13: [35],
        14: [05, 35],
        15: [05, 35],
        16: [05, 45],
        17: [10, 45],
        18: [05, 35],
        19: [35],
        20: [25],
        21: [05],
      },
    },
    'toYakusa': {
      'A': {
        8: [20, 50],
        9: [20, 50],
        10: [20, 50],
        11: [00, 10, 20, 30, 40, 50],
        12: [00, 10, 20, 30, 40, 50],
        13: [00, 15, 30, 45],
        14: [00, 10, 20, 30, 40, 45, 50, 55],
        15: [00, 10, 20, 30, 40, 50],
        16: [00, 05, 10, 15, 25, 30, 35, 40, 45, 50, 55],
        17: [00, 10, 15, 20, 25, 30, 35, 40, 45, 55],
        18: [00, 10, 20, 30, 40, 50],
        19: [00, 15, 30, 45],
        20: [00, 15, 30, 45],
        21: [00, 15, 30, 45],
      },
      'B': {
        8: [50],
        9: [40],
        10: [05, 50],
        11: [15, 40],
        12: [10],
        13: [20, 50],
        14: [20, 50],
        15: [20, 50],
        16: [20],
        17: [00, 30, 55],
        18: [20, 50],
        19: [20, 50],
        20: [40],
        21: [30],
      },
      'C': {
        8: [50],
        9: [40],
        10: [05, 50],
        11: [15, 40],
        12: [10],
        13: [20, 50],
        14: [20, 50],
        15: [20, 50],
        16: [20],
        17: [00, 30, 55],
        18: [20, 50],
        19: [20, 50],
        20: [40],
        21: [30],
      },
    },
  },
};
const Map<String, String> dayDaiya = {
  '2023-4-3': 'C',
  '2023-4-4': 'C',
  '2023-4-5': 'C',
  '2023-4-6': 'A',
  '2023-4-7': 'A',
  '2023-4-10': 'A',
  '2023-4-11': 'A',
  '2023-4-12': 'A',
  '2023-4-13': 'A',
  '2023-4-14': 'A',
  '2023-4-17': 'A',
  '2023-4-18': 'A',
  '2023-4-19': 'A',
  '2023-4-20': 'A',
  '2023-4-21': 'A',
  '2023-4-24': 'A',
  '2023-4-25': 'A',
  '2023-4-26': 'A',
  '2023-4-27': 'A',
  '2023-4-28': 'A',
  '2023-5-1': 'A',
  '2023-5-2': 'A',
  '2023-5-8': 'A',
  '2023-5-9': 'A',
  '2023-5-10': 'A',
  '2023-5-11': 'A',
  '2023-5-12': 'A',
  '2023-5-15': 'A',
  '2023-5-16': 'A',
  '2023-5-17': 'A',
  '2023-5-18': 'A',
  '2023-5-19': 'A',
  '2023-5-22': 'A',
  '2023-5-23': 'A',
  '2023-5-24': 'A',
  '2023-5-25': 'A',
  '2023-5-26': 'A',
  '2023-5-29': 'A',
  '2023-5-30': 'A',
  '2023-5-31': 'A',
  '2023-6-1': 'A',
  '2023-6-2': 'A',
  '2023-6-3': 'A',
  '2023-6-5': 'A',
  '2023-6-6': 'A',
  '2023-6-7': 'A',
  '2023-6-8': 'A',
  '2023-6-9': 'A',
  '2023-6-12': 'A',
  '2023-6-13': 'A',
  '2023-6-14': 'A',
  '2023-6-15': 'A',
  '2023-6-16': 'A',
  '2023-6-19': 'A',
  '2023-6-20': 'A',
  '2023-6-21': 'A',
  '2023-6-22': 'A',
  '2023-6-23': 'A',
  '2023-6-26': 'A',
  '2023-6-27': 'A',
  '2023-6-28': 'A',
  '2023-6-29': 'A',
  '2023-6-30': 'A',
  '2023-7-3': 'A',
  '2023-7-4': 'A',
  '2023-7-5': 'A',
  '2023-7-6': 'A',
  '2023-7-7': 'A',
  '2023-7-10': 'A',
  '2023-7-11': 'A',
  '2023-7-12': 'A',
  '2023-7-13': 'A',
  '2023-7-14': 'A',
  '2023-7-15': 'A',
  '2023-7-16': 'A',
  '2023-7-18': 'A',
  '2023-7-19': 'A',
  '2023-7-20': 'A',
  '2023-7-21': 'A',
  '2023-7-22': 'A',
  '2023-7-23': 'A',
  '2023-7-24': 'A',
  '2023-7-25': 'A',
  '2023-7-26': 'A',
  '2023-7-27': 'A',
  '2023-7-28': 'A',
  '2023-7-31': 'A',
  '2023-8-1': 'A',
  '2023-8-2': 'A',
  '2023-8-3': 'A',
  '2023-8-4': 'A',
  '2023-8-7': 'A',
  '2023-8-8': 'C',
  '2023-8-9': 'A',
  '2023-8-10': 'C',
  '2023-8-17': 'C',
  '2023-8-18': 'C',
  '2023-8-21': 'C',
  '2023-8-22': 'C',
  '2023-8-23': 'C',
  '2023-8-24': 'C',
  '2023-8-25': 'C',
  '2023-8-28': 'C',
  '2023-8-29': 'C',
  '2023-8-30': 'C',
  '2023-8-31': 'C',
  '2023-9-1': 'C',
  '2023-9-4': 'A',
  '2023-9-5': 'A',
  '2023-9-6': 'A',
  '2023-9-7': 'C',
  '2023-9-8': 'C',
  '2023-9-11': 'C',
  '2023-9-12': 'C',
  '2023-9-13': 'C',
  '2023-9-14': 'C',
  '2023-9-15': 'C',
  '2023-9-19': 'A',
  '2023-9-20': 'A',
  '2023-9-21': 'B',
  '2023-9-22': 'A',
  '2023-9-25': 'A',
  '2023-9-26': 'A',
  '2023-9-27': 'A',
  '2023-9-28': 'A',
  '2023-9-29': 'A',
  '2023-10-2': 'A',
  '2023-10-3': 'A',
  '2023-10-4': 'A',
  '2023-10-5': 'B',
  '2023-10-6': 'B',
  '2023-10-7': 'A',
  '2023-10-8': 'A',
  '2023-10-10': 'A',
  '2023-10-11': 'A',
  '2023-10-12': 'A',
  '2023-10-13': 'A',
  '2023-10-16': 'A',
  '2023-10-17': 'A',
  '2023-10-18': 'A',
  '2023-10-19': 'A',
  '2023-10-20': 'A',
  '2023-10-21': 'A',
  '2023-10-23': 'A',
  '2023-10-24': 'A',
  '2023-10-25': 'A',
  '2023-10-26': 'A',
  '2023-10-27': 'A',
  '2023-10-30': 'A',
  '2023-10-31': 'A',
  '2023-11-1': 'B',
  '2023-11-2': 'A',
  '2023-11-3': 'A',
  '2023-11-4': 'A',
  '2023-11-5': 'A',
  '2023-11-6': 'A',
  '2023-11-7': 'A',
  '2023-11-8': 'A',
  '2023-11-9': 'A',
  '2023-11-10': 'A',
  '2023-11-11': 'A',
  '2023-11-12': 'A',
  '2023-11-14': 'A',
  '2023-11-15': 'A',
  '2023-11-16': 'A',
  '2023-11-17': 'A',
  '2023-11-18': 'A',
  '2023-11-20': 'A',
  '2023-11-21': 'A',
  '2023-11-22': 'A',
  '2023-11-24': 'A',
  '2023-11-25': 'A',
  '2023-11-27': 'A',
  '2023-11-28': 'A',
  '2023-11-29': 'A',
  '2023-11-30': 'A',
  '2023-12-1': 'A',
  '2023-12-2': 'A',
  '2023-12-3': 'A',
  '2023-12-4': 'A',
  '2023-12-5': 'A',
  '2023-12-6': 'A',
  '2023-12-7': 'A',
  '2023-12-8': 'A',
  '2023-12-11': 'A',
  '2023-12-12': 'A',
  '2023-12-13': 'A',
  '2023-12-14': 'A',
  '2023-12-15': 'A',
  '2023-12-16': 'A',
  '2023-12-18': 'A',
  '2023-12-19': 'A',
  '2023-12-20': 'A',
  '2023-12-21': 'A',
  '2023-12-22': 'A',
  '2023-12-25': 'A',
  '2024-1-11': 'A',
  '2024-1-12': 'A',
  '2024-1-13': 'A',
  '2024-1-14': 'A',
  '2024-1-15': 'A',
  '2024-1-16': 'A',
  '2024-1-17': 'A',
  '2024-1-18': 'A',
  '2024-1-19': 'A',
  '2024-1-22': 'A',
  '2024-1-24': 'A',
  '2024-1-25': 'A',
  '2024-1-26': 'A',
  '2024-1-27': 'A',
  '2024-1-28': 'A',
  '2024-1-29': 'A',
  '2024-1-30': 'A',
  '2024-1-31': 'A',
  '2024-2-1': 'A',
  '2024-2-2': 'A',
  '2024-2-5': 'A',
  '2024-2-6': 'A',
  '2024-2-7': 'A',
  '2024-2-8': 'A',
  '2024-2-9': 'A',
  '2024-2-13': 'A',
  '2024-2-14': 'A',
  '2024-2-15': 'A',
  '2024-2-16': 'A',
  '2024-2-19': 'C',
  '2024-2-20': 'C',
  '2024-2-21': 'C',
  '2024-2-22': 'C',
  '2024-2-26': 'C',
  '2024-2-27': 'C',
  '2024-2-28': 'C',
  '2024-2-29': 'C',
  '2024-3-1': 'C',
  '2024-3-4': 'A',
  '2024-3-5': 'C',
  '2024-3-6': 'C',
  '2024-3-7': 'C',
  '2024-3-8': 'C',
  '2024-3-11': 'C',
  '2024-3-12': 'C',
  '2024-3-13': 'C',
  '2024-3-14': 'C',
  '2024-3-15': 'C',
  '2024-3-18': 'C',
  '2024-3-19': 'C',
  '2024-3-21': 'C',
  '2024-3-22': 'C',
  '2024-3-23': 'A',
  '2024-3-25': 'C',
  '2024-3-26': 'C',
  '2024-3-27': 'C',
  '2024-3-28': 'C',
  '2024-3-29': 'C',
};
const Map<String, String> vehicleName = {
  'linimo': 'リニモ',
  'bus': 'シャトルバス',
};
const Map<String, String> destinationName = {
  'toYakusa': '(八草行)',
  'toAIT': '(愛工大行)',
  'toHujigaoka': '(藤が丘行)',
};
