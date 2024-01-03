class Contact {
  const Contact({
    required this.name,
    this.mail,
    required this.phone,
    required this.explain,
  });

  final String name;
  final String? mail;
  final String phone;
  final String explain;
}
