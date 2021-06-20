import 'dart:math';

import 'package:hukum_pro/arch/domain/entity/misc/version_entity.dart';
import 'package:hukum_pro/arch/domain/repository/bulk_laws_repository.dart';
import 'package:hukum_pro/arch/domain/use_case/reinitialize_whole_data_use_case.dart';
import 'package:hukum_pro/common/exception/built_in.dart';

class ReinitializeWholeDataUseCaseImpl implements ReinitializeWholeDataUseCase {
  BulkLawsRepository bulkLawsRepository;

  ReinitializeWholeDataUseCaseImpl(this.bulkLawsRepository);

  @override
  Future<void> execute(VersionEntity version) async {
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
    }

    // Parse that file
  }
}
