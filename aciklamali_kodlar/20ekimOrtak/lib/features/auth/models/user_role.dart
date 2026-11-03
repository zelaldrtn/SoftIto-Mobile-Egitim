/// Kullanıcı rolü: Yatırımcı veya Yatırım Alan Girişimci.
// enum: kullanıcı rollerini (yatırımcı / girişimci) güvenli ve tip korumalı seçenekler olarak tanımlar
enum UserRole {
  investor('Yatırımcı', 'Yeni girişimler keşfet, melek yatırım yap ve mentörlük ver.'),
  entrepreneur('Yatırım Alan Girişimci', 'Projeni sergile, tohum fon topla ve yatırımcı ağı kazan.');

  final String label;
  final String description;

  const UserRole(this.label, this.description);

  // rolün yatırımcı mı yoksa girişimci mi olduğunu pratik kontrol eden getter'lar
  bool get isInvestor => this == UserRole.investor;
  bool get isEntrepreneur => this == UserRole.entrepreneur;
}

