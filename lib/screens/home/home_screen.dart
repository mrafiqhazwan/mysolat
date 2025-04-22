import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:mysolat_app/services/prayer_provider.dart';
import 'package:mysolat_app/widgets/prayer_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<PrayerProvider>(
          builder: (context, prayerProvider, child) {
            if (prayerProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (prayerProvider.errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Theme.of(context).colorScheme.error,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading prayer times',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      prayerProvider.errorMessage!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => prayerProvider.refreshPrayerTimes(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => prayerProvider.refreshPrayerTimes(),
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 120.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'MySolat',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            DateFormat('EEEE, d MMM y').format(DateTime.now()),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.primaryContainer,
                            ],
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
                          // Navigate to settings
                        },
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: prayerProvider.currentPrayer != null
                        ? CurrentPrayerCard(
                            prayer: prayerProvider.currentPrayer!,
                            progress: prayerProvider.progress,
                            timeRemaining: prayerProvider.timeRemaining,
                          )
                        : const SizedBox.shrink(),
                  ),
                  SliverToBoxAdapter(
                    child: prayerProvider.nextPrayer != null
                        ? NextPrayerCard(
                            prayer: prayerProvider.nextPrayer!,
                          )
                        : const SizedBox.shrink(),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Today\'s Prayer Times',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const Divider(),
                              if (prayerProvider.prayerTimes != null) ...[
                                ..._buildPrayerTimesList(
                                  context,
                                  prayerProvider,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildPrayerTimesList(
    BuildContext context,
    PrayerProvider prayerProvider,
  ) {
    final prayers = [
      'Fajr',
      'Sunrise',
      'Dhuhr',
      'Asr',
      'Maghrib',
      'Isha'
    ];
    final times = [
      prayerProvider.prayerTimes!.fajr,
      prayerProvider.prayerTimes!.sunrise,
      prayerProvider.prayerTimes!.dhuhr,
      prayerProvider.prayerTimes!.asr,
      prayerProvider.prayerTimes!.maghrib,
      prayerProvider.prayerTimes!.isha,
    ];

    return List.generate(
      prayers.length,
      (index) {
        final isCurrent = prayerProvider.currentPrayer?.name == prayers[index];
        final isNext = prayerProvider.nextPrayer?.name == prayers[index];
        
        return ListTile(
          leading: Icon(
            _getPrayerIcon(prayers[index]),
            color: isCurrent
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          title: Text(
            prayers[index],
            style: TextStyle(
              fontWeight: (isCurrent || isNext) ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          trailing: Text(
            DateFormat('h:mm a').format(times[index]),
            style: TextStyle(
              fontWeight: (isCurrent || isNext) ? FontWeight.bold : FontWeight.normal,
              color: (isCurrent || isNext)
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          tileColor: isCurrent
              ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
              : isNext
                  ? Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.2)
                  : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
        );
      },
    );
  }

  IconData _getPrayerIcon(String prayerName) {
    switch (prayerName) {
      case 'Fajr':
        return Icons.wb_twilight;
      case 'Sunrise':
        return Icons.wb_sunny_outlined;
      case 'Dhuhr':
        return Icons.wb_sunny;
      case 'Asr':
        return Icons.sunny_snowing;
      case 'Maghrib':
        return Icons.nightlight_round;
      case 'Isha':
        return Icons.nightlight;
      default:
        return Icons.access_time;
    }
  }
} 