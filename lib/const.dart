import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Measure {
  // MARK: - Space

  static const double s_2 = 2;
  static const double s_4 = 4;
  static const double s_8 = 8;
  static const double s_12 = 12;
  static const double s_16 = 16;

  // MARK: - Gap

  static const Gap g_4 = Gap(Measure.s_4);
  static const Gap g_8 = Gap(Measure.s_8);
  static const Gap g_12 = Gap(Measure.s_12);
  static const Gap g_16 = Gap(Measure.s_16);

  // MARK: - EdgeInsets(padding)

  static const EdgeInsets p_a2 = EdgeInsets.all(Measure.s_2);
  static const EdgeInsets p_l4 = EdgeInsets.only(left: Measure.s_4);
  static const EdgeInsets p_t4 = EdgeInsets.only(top: Measure.s_4);
  static const EdgeInsets p_r4 = EdgeInsets.only(right: Measure.s_4);
  static const EdgeInsets p_b4 = EdgeInsets.only(bottom: Measure.s_4);
  static const EdgeInsets p_h4 = EdgeInsets.symmetric(horizontal: Measure.s_4);
  static const EdgeInsets p_v4 = EdgeInsets.symmetric(vertical: Measure.s_4);
  static const EdgeInsets p_a4 = EdgeInsets.all(Measure.s_4);
  static const EdgeInsets p_l8 = EdgeInsets.only(left: Measure.s_8);
  static const EdgeInsets p_t8 = EdgeInsets.only(top: Measure.s_8);
  static const EdgeInsets p_r8 = EdgeInsets.only(right: Measure.s_8);
  static const EdgeInsets p_b8 = EdgeInsets.only(bottom: Measure.s_8);
  static const EdgeInsets p_h8 = EdgeInsets.symmetric(horizontal: Measure.s_8);
  static const EdgeInsets p_v8 = EdgeInsets.symmetric(vertical: Measure.s_8);
  static const EdgeInsets p_a8 = EdgeInsets.all(Measure.s_8);
  static const EdgeInsets p_l12 = EdgeInsets.only(left: Measure.s_12);
  static const EdgeInsets p_t12 = EdgeInsets.only(top: Measure.s_12);
  static const EdgeInsets p_r12 = EdgeInsets.only(right: Measure.s_12);
  static const EdgeInsets p_b12 = EdgeInsets.only(bottom: Measure.s_12);
  static const EdgeInsets p_h12 =
      EdgeInsets.symmetric(horizontal: Measure.s_12);
  static const EdgeInsets p_v12 = EdgeInsets.symmetric(vertical: Measure.s_12);
  static const EdgeInsets p_a12 = EdgeInsets.all(Measure.s_12);
  static const EdgeInsets p_l16 = EdgeInsets.only(left: Measure.s_16);
  static const EdgeInsets p_t16 = EdgeInsets.only(top: Measure.s_16);
  static const EdgeInsets p_r16 = EdgeInsets.only(right: Measure.s_16);
  static const EdgeInsets p_b16 = EdgeInsets.only(bottom: Measure.s_16);
  static const EdgeInsets p_h16 =
      EdgeInsets.symmetric(horizontal: Measure.s_16);
  static const EdgeInsets p_v16 = EdgeInsets.symmetric(vertical: Measure.s_16);
  static const EdgeInsets p_a16 = EdgeInsets.all(Measure.s_16);

  // MARK: - Corner Radius

  static const r_2 = Radius.circular(2);
  static const r_4 = Radius.circular(4);
  static const r_6 = Radius.circular(6);
  static const r_8 = Radius.circular(8);

  // MARK: - Border Radius

  static const br_2 = BorderRadius.all(Measure.r_2);
  static const br_4 = BorderRadius.all(Measure.r_4);
  static const br_6 = BorderRadius.all(Measure.r_6);
  static const br_8 = BorderRadius.all(Measure.r_8);
}

class ClassPeriod {
  static const first_period_start = '09:00';
  static const first_period_end = '10:30';
  static const second_period_start = '10:40';
  static const second_period_end = '12:10';
  static const third_period_start = '13:00';
  static const third_period_end = '14:30';
  static const fourth_period_start = '14:40';
  static const fourth_period_end = '16:10';
  static const fifth_period_start = '16:20';
  static const fifth_period_end = '17:50';
  static const sixth_period_start = '18:00';
  static const sixth_period_end = '19:30';
  static const OneWeek = <String>['月', '火', '水', '木', '金'];
}

class Vehicle {
  static const Map<String, Map<String, Map<int, List<int>>>> daiya = {
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
    }
  };
  static const Map<String, String> name = {'linimo': 'リニモ', 'bus': 'シャトルバス'};
  static const Map<String, String> destinationName = {
    'toYakusa': '(八草行)',
    'toAIT': '(愛工大行)',
    'toHujigaoka': '(藤が丘行)',
  };
}
