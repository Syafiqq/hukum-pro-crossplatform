import 'dart:collection';
import 'dart:math';

import 'package:hukum_pro/arch/domain/entity/law/law_entity.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_year_entity.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';
import 'package:hukum_pro/arch/domain/repository/bulk_laws_repository.dart';
import 'package:hukum_pro/arch/domain/repository/law_menu_order_repository.dart';
import 'package:hukum_pro/arch/domain/repository/law_repository.dart';
import 'package:hukum_pro/arch/domain/repository/law_year_repository.dart';
import 'package:hukum_pro/arch/domain/use_case/reinitialize_whole_data_use_case.dart';
import 'package:hukum_pro/common/exception/built_in.dart';

class ReinitializeWholeDataUseCaseImpl implements ReinitializeWholeDataUseCase {
  BulkLawsRepository bulkLawsRepository;
  LawRepository lawRepository;
  LawYearRepository lawYearRepository;
  LawMenuOrderRepository lawMenuOrderRepository;

  var lawYearsRaw = Map<String, Map<int, int>>();

  ReinitializeWholeDataUseCaseImpl(this.bulkLawsRepository, this.lawRepository,
      this.lawYearRepository, this.lawMenuOrderRepository);

  @override
  Future<void> execute(VersionEntity version) async {
    // Download the files
    final id = version.milis;
    if (id == null) {
      throw DataFetchFailureException(null, null);
    }

    // Clear the database
    await lawRepository.deleteAll();
    await lawYearRepository.deleteAll();
    lawYearsRaw.clear();

    final lawOrder = await lawMenuOrderRepository.fetchFromRemote();
    await lawMenuOrderRepository.saveToLocal(lawOrder);

    var filenames = version.detail?.filenames ?? [];
    var files =
        await bulkLawsRepository.getFileReference(id.toString(), filenames);

    final numOfProcessed = min(files.length, filenames.length);
    files = files.sublist(0, numOfProcessed);
    filenames = filenames.sublist(0, numOfProcessed);

    for (var i = 0; i < numOfProcessed; i++) {
      final file = files[i];
      final filename = filenames[i];
      await bulkLawsRepository.downloadLaw(filename, file);

      // Parse that file and insert into law and law year
      final bulkLaws = await bulkLawsRepository.decodeFile(file);
      extractYear(bulkLaws);

      await lawRepository.addAll(bulkLaws);
    }

    await lawYearRepository.addAll(convertYearList());
  }

  Map<String, List<LawYearEntity>> convertYearList() {
    var result = Map<String, List<LawYearEntity>>();
    for (var yearLists in lawYearsRaw.entries) {
      result[yearLists.key] = yearLists.value.entries
          .map((e) => LawYearEntity(0, e.key, e.value))
          .toList();
    }
    return result;
  }

  void extractYear(List<LawEntity> bulkLaws) {
    for (var law in bulkLaws) {
      final year = law.year;
      final category = law.category;
      if (year == null || category == null) {
        continue;
      }

      if (!lawYearsRaw.containsKey(category)) {
        lawYearsRaw[category] = Map<int, int>();
      }
      if (!lawYearsRaw[category]!.containsKey(year)) {
        lawYearsRaw[category]![year] = 0;
      }
      lawYearsRaw[category]![year] = lawYearsRaw[category]![year]! + 1;
    }
  }
}
