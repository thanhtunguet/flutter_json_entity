import "package:supa_architecture/api_client/api_client.dart";
import "package:supa_architecture/filters/filters.dart";
import "package:supa_architecture/json/json.dart";

/// An abstract class that extends [ApiClient] to provide base CRUD operations
/// for repositories.
///
/// This class provides methods for listing, counting, retrieving, creating,
/// updating, deleting, approving, and rejecting entities of type [T] that
/// extends [JsonModel]. The operations use [Dio] for HTTP requests and handle
/// responses appropriately.
abstract class BaseRepository<T extends JsonModel, TFilter extends DataFilter>
    extends ApiClient {
  /// Lists entities based on the provided filter.
  ///
  /// **Parameters:**
  /// - `filter`: An instance of [TFilter] to filter the list of entities.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to a list of entities of type [T].
  Future<List<T>> list(TFilter filter) async {
    return dio
        .post(
          "/list",
          data: filter.toJson(),
        )
        .then(
          (response) => response.bodyAsList<T>(),
        );
  }

  /// Counts entities based on the provided filter.
  ///
  /// **Parameters:**
  /// - `filter`: An instance of [TFilter] to filter the entities.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to the count of entities.
  Future<int> count(TFilter filter) async {
    return dio
        .post(
          "/count",
          data: filter.toJson(),
        )
        .then(
          (response) => (response.data as num).toInt(),
        );
  }

  /// Retrieves an entity by its ID.
  ///
  /// **Parameters:**
  /// - `id`: The ID of the entity to retrieve.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to the entity of type [T].
  Future<T> getById(num id) async {
    return dio.post(
      "/get",
      data: {
        "id": id,
      },
    ).then(
      (response) => response.body<T>(),
    );
  }

  /// Creates a new entity.
  ///
  /// **Parameters:**
  /// - `entity`: The entity to create.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to the created entity of type [T].
  Future<T> create(T entity) async {
    return dio
        .post(
          "/create",
          data: entity.toJson(),
        )
        .then(
          (response) => response.body<T>(),
        );
  }

  /// Updates an existing entity.
  ///
  /// **Parameters:**
  /// - `entity`: The entity to update.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to the updated entity of type [T].
  Future<T> update(T entity) async {
    return dio
        .post(
          "/update",
          data: entity.toJson(),
        )
        .then(
          (response) => response.body<T>(),
        );
  }

  /// Deletes an entity based on the entity object.
  ///
  /// **Parameters:**
  /// - `entity`: The entity to delete.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to the deleted entity of type [T].
  Future<T> deleteByEntity(T entity) async {
    return dio
        .post(
          "/delete",
          data: entity.toJson(),
        )
        .then(
          (response) => response.body<T>(),
        );
  }

  /// Deletes an entity based on its ID.
  ///
  /// **Parameters:**
  /// - `id`: The ID of the entity to delete.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to the deleted entity of type [T].
  Future<T> deleteById(num id) async {
    return dio.post(
      "/delete",
      data: {
        "id": id,
      },
    ).then(
      (response) => response.body<T>(),
    );
  }

  /// Approves an entity based on the entity object.
  ///
  /// **Parameters:**
  /// - `entity`: The entity to approve.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to the approved entity of type [T].
  Future<T> approve(T entity) async {
    return dio
        .post(
          "/approve",
          data: entity.toJson(),
        )
        .then(
          (response) => response.body<T>(),
        );
  }

  /// Rejects an entity based on the entity object.
  ///
  /// **Parameters:**
  /// - `entity`: The entity to reject.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to the rejected entity of type [T].
  Future<T> reject(T entity) async {
    return dio
        .post(
          "/reject",
          data: entity.toJson(),
        )
        .then(
          (response) => response.body<T>(),
        );
  }

  /// Approves an entity based on its ID.
  ///
  /// **Parameters:**
  /// - `id`: The ID of the entity to approve.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to the approved entity of type [T].
  Future<T> approveById(num id) async {
    return dio.post(
      "/approve",
      data: {
        "id": id,
      },
    ).then(
      (response) => response.body<T>(),
    );
  }

  /// Rejects an entity based on its ID.
  ///
  /// **Parameters:**
  /// - `id`: The ID of the entity to reject.
  ///
  /// **Returns:**
  /// - A [Future] that resolves to the rejected entity of type [T].
  Future<T> rejectById(num id) async {
    return dio.post(
      "/reject",
      data: {
        "id": id,
      },
    ).then(
      (response) => response.body<T>(),
    );
  }
}
