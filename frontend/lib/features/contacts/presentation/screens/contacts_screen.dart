import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../providers/contacts_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ContactsScreen  (directorio puro — sin indicador de disponibilidad)
// ─────────────────────────────────────────────────────────────────────────────

class ContactsScreen extends ConsumerStatefulWidget {
  const ContactsScreen({super.key});

  @override
  ConsumerState<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends ConsumerState<ContactsScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contactsAsync = ref.watch(contactsProvider);
    final typeFilter = ref.watch(contactTypeFilterProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Contactos'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // ── Search Bar ────────────────────────────────────────────
          Container(
            color: AppColors.primaryGreen,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              controller: _searchController,
              onChanged: (val) =>
                  ref.read(contactSearchProvider.notifier).state = val,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar contactos...',
                hintStyle: const TextStyle(color: Colors.white60),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white70),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(contactSearchProvider.notifier).state = '';
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),

          // ── Type Filter Chips ─────────────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                _FilterChip(
                  label: 'Todos',
                  selected: typeFilter == null,
                  onTap: () =>
                      ref.read(contactTypeFilterProvider.notifier).state = null,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Emergencia',
                  selected: typeFilter == 'emergency',
                  onTap: () => ref
                      .read(contactTypeFilterProvider.notifier)
                      .state = 'emergency',
                  color: AppColors.error,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Profesional',
                  selected: typeFilter == 'professional',
                  onTap: () => ref
                      .read(contactTypeFilterProvider.notifier)
                      .state = 'professional',
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Comercio',
                  selected: typeFilter == 'commerce',
                  onTap: () => ref
                      .read(contactTypeFilterProvider.notifier)
                      .state = 'commerce',
                  color: AppColors.statusConfirmed,
                ),
              ],
            ),
          ),

          // ── List ──────────────────────────────────────────────────
          Expanded(
            child: contactsAsync.when(
              loading: () => const AppLoading(),
              error: (e, _) => AppErrorWidget(
                message: 'Error al cargar contactos',
                onRetry: () => ref.invalidate(contactsProvider),
              ),
              data: (contacts) {
                if (contacts.isEmpty) {
                  return const AppEmptyState(
                    icon: Icons.contacts_outlined,
                    title: 'Sin contactos',
                    subtitle: 'No se encontraron contactos con ese filtro',
                  );
                }
                return RefreshIndicator(
                  color: AppColors.primaryGreen,
                  onRefresh: () async => ref.invalidate(contactsProvider),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    itemCount: contacts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 6),
                    itemBuilder: (context, i) =>
                        _ContactCard(contact: contacts[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Filter chip ──────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primaryGreen;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? c : Colors.transparent,
          border: Border.all(color: selected ? c : AppColors.textSecondary),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textSecondary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

// ── Contact card ─────────────────────────────────────────────────────────────

class _ContactCard extends StatelessWidget {
  final ContactModel contact;
  const _ContactCard({required this.contact});

  Color get _typeColor {
    switch (contact.type) {
      case 'emergency':
        return AppColors.error;
      case 'professional':
        return AppColors.primaryGreen;
      case 'commerce':
        return AppColors.statusConfirmed;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData get _typeIcon {
    switch (contact.type) {
      case 'emergency':
        return Icons.emergency_outlined;
      case 'professional':
        return Icons.work_outline;
      case 'commerce':
        return Icons.store_outlined;
      default:
        return Icons.person_outline;
    }
  }

  Future<void> _call() async {
    final uri = Uri(scheme: 'tel', path: contact.phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _email() async {
    if (contact.email == null) return;
    final uri = Uri(scheme: 'mailto', path: contact.email!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: _typeColor.withValues(alpha: 0.12),
              child: Icon(_typeIcon, color: _typeColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          contact.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: _typeColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          contact.typeLabel,
                          style: TextStyle(
                            color: _typeColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    contact.phone,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  if (contact.description != null &&
                      contact.description!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      contact.description!,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                _IconBtn(
                  icon: Icons.phone,
                  color: AppColors.success,
                  onTap: _call,
                ),
                if (contact.email != null) ...[
                  const SizedBox(height: 4),
                  _IconBtn(
                    icon: Icons.email_outlined,
                    color: AppColors.primaryGreen,
                    onTap: _email,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _IconBtn({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}
