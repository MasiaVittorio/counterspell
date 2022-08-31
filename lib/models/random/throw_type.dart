
enum ThrowType {
  coin(
    "Flip",
  ),
  name(
    "Pick",
  ),
  dice(
    "Throw",
  );

  const ThrowType(
    this.predicate,
  );

  final String predicate;


}