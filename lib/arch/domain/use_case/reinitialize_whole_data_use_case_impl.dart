import 'dart:collection';
import 'dart:math';

import 'package:hukum_pro/arch/domain/entity/law/law_entity.dart';
import 'package:hukum_pro/arch/domain/entity/law/law_year_entity.dart';
import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';
import 'package:hukum_pro/arch/domain/repository/bulk_laws_repository.dart';
import 'package:hukum_pro/arch/domain/repository/law_repository.dart';
import 'package:hukum_pro/arch/domain/repository/law_year_repository.dart';
import 'package:hukum_pro/arch/domain/use_case/reinitialize_whole_data_use_case.dart';
import 'package:hukum_pro/common/exception/built_in.dart';

class ReinitializeWholeDataUseCaseImpl implements ReinitializeWholeDataUseCase {
  BulkLawsRepository bulkLawsRepository;
  LawRepository lawRepository;
  LawYearRepository lawYearRepository;

  var lawYearsRaw = LinkedHashMap<int, int>();

  ReinitializeWholeDataUseCaseImpl(
      this.bulkLawsRepository, this.lawRepository, this.lawYearRepository);

  @override
  Future<void> execute(VersionEntity version) async {
    // Clear the database
    await lawRepository.deleteAll();
    await lawYearRepository.deleteAll();
    lawYearsRaw.clear();

    // Download the files
    final id = version.milis;
    if (id == null) {
      throw DataFetchFailureException(null, null);
    }

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

    final lawYears = lawYearsRaw.entries
        .map((e) => LawYearEntity(e.key, e.key, e.value))
        .toList();
    await lawYearRepository.addAll(lawYears);
  }

  void extractYear(List<LawEntity> bulkLaws) {
    for (var law in bulkLaws) {
      final year = law.year;
      if (year == null) {
        continue;
      }

      if (!lawYearsRaw.containsKey(year)) {
        lawYearsRaw[year] = 0;
      }
      lawYearsRaw[year] = lawYearsRaw[year]! + 1;
    }
  }
}
