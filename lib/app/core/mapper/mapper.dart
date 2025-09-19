//* A generic contract for converting a domain model of type [I] (Input)
//* into a database companion of type [O] (Output), typically used with Drift.
//*
//* This interface supports both:
//* - Full inserts (`mapToCompanion`)
//* - Partial updates (`mapToUpdateCompanion`)
abstract class Mapper<I, O> {
  /// Maps a domain entity [input] to a fully populated Drift companion [O],
  /// suitable for an insert operation.
  O insert(I input);

  /// Maps a domain entity [input] to a partially populated Drift companion [O],
  /// suitable for an update operation (e.g. some fields may be absent).
  O update(I input);
}
