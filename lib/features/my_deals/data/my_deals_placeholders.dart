import 'package:shareplace/features/my_deals/domain/entities/my_deal_summary.dart';

const myDealsPlaceholders = [
  MyDealSummary(
    id: 'seller-pending-sofa',
    role: MyDealRole.seller,
    progress: MyDealProgress.pending,
    title: 'Canapé convertible',
    description:
        'Canapé convertible deux places en bon état, à récupérer rapidement '
        'dans le quartier.',
    coverImageUrl: 'https://picsum.photos/seed/shareplace-sofa/240/160',
    interestedCount: 3,
  ),
  MyDealSummary(
    id: 'seller-sold-table',
    role: MyDealRole.seller,
    progress: MyDealProgress.sold,
    title: 'Table basse en bois',
    description:
        'Table basse robuste avec quelques traces d’usage, parfaite pour un '
        'premier appartement.',
    coverImageUrl: 'https://picsum.photos/seed/shareplace-table/240/160',
    counterpartPhone: '06 12 34 56 78',
  ),
  MyDealSummary(
    id: 'interested-pending-microwave',
    role: MyDealRole.interested,
    progress: MyDealProgress.pending,
    title: 'Micro-ondes étudiant',
    description:
        'Micro-ondes fonctionnel, idéal pour une chambre étudiante ou une '
        'petite cuisine.',
    coverImageUrl: 'https://picsum.photos/seed/shareplace-microwave/240/160',
  ),
  MyDealSummary(
    id: 'interested-sold-desk',
    role: MyDealRole.interested,
    progress: MyDealProgress.sold,
    title: 'Bureau compact',
    description:
        'Bureau compact avec rangement latéral, disponible après validation '
        'du rendez-vous.',
    coverImageUrl: 'https://picsum.photos/seed/shareplace-desk/240/160',
    counterpartPhone: '07 98 76 54 32',
  ),
];
