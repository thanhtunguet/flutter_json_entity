import 'package:supa_architecture/api_client/api_client.dart';
import 'package:supa_architecture/filters/filters.dart';
import 'package:supa_architecture/json/json.dart';

abstract class BaseRepository<T extends JsonModel, TFilter extends DataFilter>
    extends ApiClient {
  Future<List<T>> list(TFilter filter) async {
    return dio
        .post(
          '/list',
          data: filter.toJSON(),
        )
        .then(
          (response) => response.bodyAsList<T>(),
        );
  }

  Future<int> count(TFilter filter) async {
    return dio
        .post(
          '/count',
          data: filter.toJSON(),
        )
        .then(
          (response) => (response.data as num).toInt(),
        );
  }

  Future<T> getById(num id) async {
    return dio.post(
      '/get',
      data: {
        'id': id,
      },
    ).then(
      (response) => response.body<T>(),
    );
  }

  Future<T> create(T entity) async {
    return dio
        .post(
          '/create',
          data: entity.toJSON(),
        )
        .then(
          (response) => response.body<T>(),
        );
  }

  Future<T> update(T entity) async {
    return dio
        .post(
          '/update',
          data: entity.toJSON(),
        )
        .then(
          (response) => response.body<T>(),
        );
  }

  Future<T> deleteByEntity(T entity) async {
    return dio
        .post(
          '/delete',
          data: entity.toJSON(),
        )
        .then(
          (response) => response.body<T>(),
        );
  }

  Future<T> deleteById(num id) async {
    return dio.post(
      '/delete',
      data: {
        'id': id,
      },
    ).then(
      (response) => response.body<T>(),
    );
  }

  Future<T> approve(T entity) async {
    return dio
        .post(
          '/approve',
          data: entity.toJSON(),
        )
        .then(
          (response) => response.body<T>(),
        );
  }

  Future<T> reject(T entity) async {
    return dio
        .post(
          '/reject',
          data: entity.toJSON(),
        )
        .then(
          (response) => response.body<T>(),
        );
  }

  Future<T> approveById(num id) async {
    return dio.post(
      '/approve',
      data: {
        'id': id,
      },
    ).then(
      (response) => response.body<T>(),
    );
  }

  Future<T> rejectById(num id) async {
    return dio.post(
      '/reject',
      data: {
        'id': id,
      },
    ).then(
      (response) => response.body<T>(),
    );
  }
}
