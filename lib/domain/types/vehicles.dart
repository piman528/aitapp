enum Vehicles {
  linimo(displayName: 'リニモ'),
  bus(displayName: 'シャトルバス'),
  ;

  const Vehicles({
    required this.displayName,
  });
  final String displayName;
}
