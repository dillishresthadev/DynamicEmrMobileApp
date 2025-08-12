import 'package:dynamic_emr/features/work/domain/entities/ticket_categories_entity.dart';
import 'package:dynamic_emr/features/work/domain/repository/work_repository.dart';

class TicketCategoriesUsecase {
  final WorkRepository repository;

  TicketCategoriesUsecase({required this.repository});

  Future<List<TicketCategoriesEntity>> call() async {
    return await repository.getTicketCategories();
  }
}
