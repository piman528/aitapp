const Map<DayOfWeek, String> dayOfWeekToString = {
  DayOfWeek.monday: '月',
  DayOfWeek.tuesday: '火',
  DayOfWeek.wednesday: '水',
  DayOfWeek.thurstay: '木',
  DayOfWeek.friday: '金',
  DayOfWeek.saturday: '土',
  DayOfWeek.sunday: '月',
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

const Map<String, Map<String, Map<int, List<int>>>> daiya = {
  'linimo': {
    'toHujigaoka': {
      1: [11, 22, 23, 33],
      2: [12, 23, 29, 33],
    },
    'toYakusa': {
      3: [11, 22, 23, 33],
      4: [11, 22, 27, 33],
    },
  },
  'bus': {
    'toAIT': {
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
    'toYakusa': {
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
  },
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
