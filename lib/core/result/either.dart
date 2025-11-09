class Either<L, R> {
  Either._(this._left, this._right);

  final L? _left;
  final R? _right;

  bool get isLeft => _left != null;
  bool get isRight => _right != null;

  L get left => _left!;
  R get right => _right!;

  factory Either.left(L l) => Either._(l, null);
  factory Either.right(R r) => Either._(null, r);
}
