import 'package:disciple/app/core/usecase/disciple_usecase.dart';
import 'package:disciple/features/community/data/service_impl/module/module.dart';
import 'package:disciple/features/community/domain/usecase/church_usecases.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addChurchUseCaseImpl = Provider<DiscipleUseCaseWithRequiredParam>(
  (ref) => AddChurchUseCaseImpl(service: ref.read(churchServiceModule)),
);

final getChurchesUseCaseImpl = Provider<DiscipleUseCaseWithOptionalParam>(
  (ref) => GetChurchesUseCaseImpl(service: ref.read(churchServiceModule)),
);

final getChurchByIdUseCaseImpl = Provider<DiscipleUseCaseWithRequiredParam>(
  (ref) => GetChurchByIdUseCaseImpl(service: ref.read(churchServiceModule)),
);

final updateChurchUseCaseImpl = Provider<DiscipleUseCaseWithRequiredParam>(
  (ref) => UpdateChurchUseCaseImpl(service: ref.read(churchServiceModule)),
);

final deleteChurchUseCaseImpl = Provider<DiscipleUseCaseWithRequiredParam>(
  (ref) => DeleteChurchUseCaseImpl(service: ref.read(churchServiceModule)),
);

final acceptChurchInviteUseCaseImpl =
    Provider<DiscipleUseCaseWithRequiredParam>(
      (ref) =>
          AcceptChurchInviteUseCaseImpl(service: ref.read(churchServiceModule)),
    );

final declineChurchInviteUseCaseImpl =
    Provider<DiscipleUseCaseWithRequiredParam>(
      (ref) => DeclineChurchInviteUseCaseImpl(
        service: ref.read(churchServiceModule),
      ),
    );

final inviteMemberUseCaseImpl = Provider<DiscipleUseCaseWithRequiredParam>(
  (ref) => InviteMemberUseCaseImpl(service: ref.read(churchServiceModule)),
);

final removeMemberFromChurchUseCaseImpl =
    Provider<DiscipleUseCaseWithRequiredParam>(
      (ref) => RemoveMemberFromChurchUseCaseImpl(
        service: ref.read(churchServiceModule),
      ),
    );

final updateMembersRoleInChurchUseCaseImpl =
    Provider<DiscipleUseCaseWithRequiredParam>(
      (ref) => UpdateMembersRoleInChurchUseCaseImpl(
        service: ref.read(churchServiceModule),
      ),
    );

final banMemberUseCaseImpl = Provider<DiscipleUseCaseWithRequiredParam>(
  (ref) => BanMemberUseCaseImpl(service: ref.read(churchServiceModule)),
);

final searchChurchesUseCaseImpl = Provider<DiscipleUseCaseWithRequiredParam>(
  (ref) => SearchChurchesUseCaseImpl(service: ref.read(churchServiceModule)),
);

final getLocationsUseCaseImpl = Provider<DiscipleUseCaseWithRequiredParam>(
  (ref) => GetLocationsUseCaseImpl(service: ref.read(churchServiceModule)),
);

final getPostsUseCaseImpl = Provider<DiscipleUseCaseWithOptionalParam>(
  (ref) => GetPostsUseCaseImpl(service: ref.read(churchServiceModule)),
);

final getGalleriesUseCaseImpl = Provider<DiscipleUseCaseWithRequiredParam>(
  (ref) => GetGalleriesUseCaseImpl(service: ref.read(churchServiceModule)),
);
