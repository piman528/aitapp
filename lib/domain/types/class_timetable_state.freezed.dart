// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'class_timetable_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ClassTimeTableState {
  Map<int, Map<Semester, Map<DayOfWeek, Map<int, Class>>>> get timetable =>
      throw _privateConstructorUsedError;
  int get selectYear => throw _privateConstructorUsedError;
  Semester get selectSemester => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ClassTimeTableStateCopyWith<ClassTimeTableState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClassTimeTableStateCopyWith<$Res> {
  factory $ClassTimeTableStateCopyWith(
          ClassTimeTableState value, $Res Function(ClassTimeTableState) then) =
      _$ClassTimeTableStateCopyWithImpl<$Res, ClassTimeTableState>;
  @useResult
  $Res call(
      {Map<int, Map<Semester, Map<DayOfWeek, Map<int, Class>>>> timetable,
      int selectYear,
      Semester selectSemester});
}

/// @nodoc
class _$ClassTimeTableStateCopyWithImpl<$Res, $Val extends ClassTimeTableState>
    implements $ClassTimeTableStateCopyWith<$Res> {
  _$ClassTimeTableStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timetable = null,
    Object? selectYear = null,
    Object? selectSemester = null,
  }) {
    return _then(_value.copyWith(
      timetable: null == timetable
          ? _value.timetable
          : timetable // ignore: cast_nullable_to_non_nullable
              as Map<int, Map<Semester, Map<DayOfWeek, Map<int, Class>>>>,
      selectYear: null == selectYear
          ? _value.selectYear
          : selectYear // ignore: cast_nullable_to_non_nullable
              as int,
      selectSemester: null == selectSemester
          ? _value.selectSemester
          : selectSemester // ignore: cast_nullable_to_non_nullable
              as Semester,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClassTimeTableStateImplCopyWith<$Res>
    implements $ClassTimeTableStateCopyWith<$Res> {
  factory _$$ClassTimeTableStateImplCopyWith(_$ClassTimeTableStateImpl value,
          $Res Function(_$ClassTimeTableStateImpl) then) =
      __$$ClassTimeTableStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<int, Map<Semester, Map<DayOfWeek, Map<int, Class>>>> timetable,
      int selectYear,
      Semester selectSemester});
}

/// @nodoc
class __$$ClassTimeTableStateImplCopyWithImpl<$Res>
    extends _$ClassTimeTableStateCopyWithImpl<$Res, _$ClassTimeTableStateImpl>
    implements _$$ClassTimeTableStateImplCopyWith<$Res> {
  __$$ClassTimeTableStateImplCopyWithImpl(_$ClassTimeTableStateImpl _value,
      $Res Function(_$ClassTimeTableStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timetable = null,
    Object? selectYear = null,
    Object? selectSemester = null,
  }) {
    return _then(_$ClassTimeTableStateImpl(
      timetable: null == timetable
          ? _value._timetable
          : timetable // ignore: cast_nullable_to_non_nullable
              as Map<int, Map<Semester, Map<DayOfWeek, Map<int, Class>>>>,
      selectYear: null == selectYear
          ? _value.selectYear
          : selectYear // ignore: cast_nullable_to_non_nullable
              as int,
      selectSemester: null == selectSemester
          ? _value.selectSemester
          : selectSemester // ignore: cast_nullable_to_non_nullable
              as Semester,
    ));
  }
}

/// @nodoc

class _$ClassTimeTableStateImpl implements _ClassTimeTableState {
  const _$ClassTimeTableStateImpl(
      {required final Map<int, Map<Semester, Map<DayOfWeek, Map<int, Class>>>>
          timetable,
      required this.selectYear,
      required this.selectSemester})
      : _timetable = timetable;

  final Map<int, Map<Semester, Map<DayOfWeek, Map<int, Class>>>> _timetable;
  @override
  Map<int, Map<Semester, Map<DayOfWeek, Map<int, Class>>>> get timetable {
    if (_timetable is EqualUnmodifiableMapView) return _timetable;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_timetable);
  }

  @override
  final int selectYear;
  @override
  final Semester selectSemester;

  @override
  String toString() {
    return 'ClassTimeTableState(timetable: $timetable, selectYear: $selectYear, selectSemester: $selectSemester)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClassTimeTableStateImpl &&
            const DeepCollectionEquality()
                .equals(other._timetable, _timetable) &&
            (identical(other.selectYear, selectYear) ||
                other.selectYear == selectYear) &&
            (identical(other.selectSemester, selectSemester) ||
                other.selectSemester == selectSemester));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_timetable),
      selectYear,
      selectSemester);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ClassTimeTableStateImplCopyWith<_$ClassTimeTableStateImpl> get copyWith =>
      __$$ClassTimeTableStateImplCopyWithImpl<_$ClassTimeTableStateImpl>(
          this, _$identity);
}

abstract class _ClassTimeTableState implements ClassTimeTableState {
  const factory _ClassTimeTableState(
      {required final Map<int, Map<Semester, Map<DayOfWeek, Map<int, Class>>>>
          timetable,
      required final int selectYear,
      required final Semester selectSemester}) = _$ClassTimeTableStateImpl;

  @override
  Map<int, Map<Semester, Map<DayOfWeek, Map<int, Class>>>> get timetable;
  @override
  int get selectYear;
  @override
  Semester get selectSemester;
  @override
  @JsonKey(ignore: true)
  _$$ClassTimeTableStateImplCopyWith<_$ClassTimeTableStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
