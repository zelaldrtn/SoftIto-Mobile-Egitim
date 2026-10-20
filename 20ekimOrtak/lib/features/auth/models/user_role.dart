/// Kullanıcı rolü: Yatırımcı veya Yatırım Alan Girişimci.
enum UserRole {
  investor('Yatırımcı', 'Yeni girişimler keşfet, melek yatırım yap ve mentörlük ver.'),
  entrepreneur('Yatırım Alan Girişimci', 'Projeni sergile, tohum fon topla ve yatırımcı ağı kazan.');

  final String label;
  final String description;

  const UserRole(this.label, this.description);

  bool get isInvestor => this == UserRole.investor;
  bool get isEntrepreneur => this == UserRole.entrepreneur;
}
