class ListArgs {
  final String? category; // null 表示全部
  final bool onlyHigh; // 仅看借阅量 ≥50

  const ListArgs({this.category, this.onlyHigh = false});
}
