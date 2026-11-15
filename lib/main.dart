import 'package:flutter/material.dart';

void main() {
  runApp(const AudioApp());
}

const _green = Color(0xFF356B60);
const _ink = Color(0xFF26312F);
const _muted = Color(0xFF71807C);
const _paper = Color(0xFFF7F5F0);
const _line = Color(0xFFE7E6E0);

class AudioItem {
  const AudioItem({
    required this.title,
    required this.category,
    required this.duration,
    required this.description,
    required this.artworkColor,
  });

  final String title;
  final String category;
  final String duration;
  final String description;
  final Color artworkColor;
}

const _audios = <AudioItem>[
  AudioItem(
    title: 'Un momento para respirar',
    category: 'Bienestar',
    duration: '12 min',
    description:
        'Una pausa guiada para bajar el ritmo, respirar con calma y volver al presente.',
    artworkColor: Color(0xFFD8E5DC),
  ),
  AudioItem(
    title: 'Pausa en medio del día',
    category: 'Pausas',
    duration: '8 min',
    description:
        'Tómate unos minutos para descansar la mente y continuar con más claridad.',
    artworkColor: Color(0xFFE9DFCF),
  ),
  AudioItem(
    title: 'Prepararse para descansar',
    category: 'Descanso',
    duration: '18 min',
    description:
        'Una guía tranquila para acompañar el cierre del día y prepararte para dormir.',
    artworkColor: Color(0xFFD9DFEA),
  ),
  AudioItem(
    title: 'Enfoque y claridad',
    category: 'Enfoque',
    duration: '10 min',
    description:
        'Un ejercicio breve para ordenar tus ideas y dedicar atención a lo importante.',
    artworkColor: Color(0xFFE8D9D0),
  ),
];

class AudioApp extends StatelessWidget {
  const AudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _green,
      surface: _paper,
      brightness: Brightness.light,
    );

    return MaterialApp(
      title: 'Nombre provisional',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: _paper,
        appBarTheme: const AppBarTheme(
          backgroundColor: _paper,
          foregroundColor: _ink,
          surfaceTintColor: Colors.transparent,
        ),
        textTheme: ThemeData.light().textTheme.apply(
              bodyColor: _ink,
              displayColor: _ink,
            ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: _paper,
          indicatorColor: _green.withOpacity(.12),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _line),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _line),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _green, width: 1.5),
          ),
        ),
      ),
      home: const AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

enum _AuthMode { signIn, signUp, resetPassword }

class _AuthScreenState extends State<AuthScreen> {
  _AuthMode _mode = _AuthMode.signIn;
  bool _obscurePassword = true;

  String get _title {
    switch (_mode) {
      case _AuthMode.signIn:
        return 'Qué bueno tenerte aquí';
      case _AuthMode.signUp:
        return 'Crea tu cuenta';
      case _AuthMode.resetPassword:
        return 'Recupera tu contraseña';
    }
  }

  void _continue() {
    if (_mode == _AuthMode.resetPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Listo. Revisa tu correo electrónico.')),
      );
      setState(() => _mode = _AuthMode.signIn);
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => _mode == _AuthMode.signUp
            ? const TrialIntroScreen()
            : const AppShell(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isReset = _mode == _AuthMode.resetPassword;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _BrandMark(),
                  const SizedBox(height: 32),
                  Text(
                    _title,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isReset
                        ? 'Te enviaremos instrucciones para recuperar el acceso.'
                        : 'Escucha a tu ritmo, cuando quieras.',
                    style: const TextStyle(color: _muted, height: 1.5),
                  ),
                  const SizedBox(height: 28),
                  if (_mode == _AuthMode.signUp) ...[
                    const TextField(
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: 'Nombre',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                  const TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Correo electrónico',
                      prefixIcon: Icon(Icons.mail_outline),
                    ),
                  ),
                  if (!isReset) ...[
                    const SizedBox(height: 14),
                    TextField(
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (_mode == _AuthMode.signIn)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () =>
                            setState(() => _mode = _AuthMode.resetPassword),
                        child: const Text('¿Olvidaste tu contraseña?'),
                      ),
                    )
                  else
                    const SizedBox(height: 22),
                  FilledButton(
                    onPressed: _continue,
                    style: FilledButton.styleFrom(
                      backgroundColor: _green,
                      minimumSize: const Size.fromHeight(54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      isReset
                          ? 'Enviar instrucciones'
                          : _mode == _AuthMode.signUp
                              ? 'Crear cuenta'
                              : 'Iniciar sesión',
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (!isReset)
                    TextButton(
                      onPressed: () => setState(
                        () => _mode = _mode == _AuthMode.signIn
                            ? _AuthMode.signUp
                            : _AuthMode.signIn,
                      ),
                      child: Text(
                        _mode == _AuthMode.signIn
                            ? '¿No tienes cuenta? Crear cuenta'
                            : '¿Ya tienes cuenta? Iniciar sesión',
                      ),
                    )
                  else
                    TextButton(
                      onPressed: () =>
                          setState(() => _mode = _AuthMode.signIn),
                      child: const Text('Volver a iniciar sesión'),
                    ),
                  const SizedBox(height: 16),
                  const Text(
                    'Prototipo visual: el acceso todavía no está conectado a un servicio de cuentas.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _muted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TrialIntroScreen extends StatelessWidget {
  const TrialIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _IllustrationIcon(
                    icon: Icons.headphones_rounded,
                    color: Color(0xFFE5EDE7),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Empieza con 7 días gratis',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Activa tu prueba para explorar la biblioteca completa. Al finalizar, podrás elegir si quieres contratar la suscripción mensual. No se realizará un cobro automático.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _muted, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  const _InfoTile(
                    icon: Icons.schedule,
                    title: '7 días de acceso',
                    subtitle: 'La prueba empieza al activarla.',
                  ),
                  const _InfoTile(
                    icon: Icons.credit_card_outlined,
                    title: 'Sin cobro automático',
                    subtitle: 'Al terminar, tú decides si continúas.',
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (_) => const AppShell(),
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: _green,
                      minimumSize: const Size.fromHeight(54),
                    ),
                    child: const Text('Activar prueba gratis'),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Prototipo visual: la fecha real de inicio y el acceso se gestionarán en el servidor.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _muted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _tab = 0;
  AudioItem _currentAudio = _audios.first;
  bool _hasCurrentAudio = false;
  bool _isPlaying = false;
  bool _isSubscribed = false;
  bool _extraUnlocked = false;

  void _openPlayer([AudioItem? audio]) {
    setState(() {
      _currentAudio = audio ?? _currentAudio;
      _hasCurrentAudio = true;
      _isPlaying = true;
    });
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PlayerScreen(
          audio: _currentAudio,
          isPlaying: _isPlaying,
          onPlayingChanged: (value) => setState(() => _isPlaying = value),
        ),
      ),
    );
  }

  void _openAdmin() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const AdminScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    final pages = [
      HomeScreen(
        onPlay: _openPlayer,
        onBrowseCategory: (category) => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => CategoryScreen(
              category: category,
              onPlay: _openPlayer,
            ),
          ),
        ),
        onBrowseAll: () => setState(() => _tab = 1),
        onOpenExtra: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => ExtraScreen(
              unlocked: _extraUnlocked,
              onPlay: _openPlayer,
              onUnlock: () => setState(() => _extraUnlocked = true),
            ),
          ),
        ),
        onOpenPlan: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => SubscriptionScreen(
              subscribed: _isSubscribed,
              onSubscribe: () => setState(() => _isSubscribed = true),
            ),
          ),
        ),
      ),
      ExploreScreen(onPlay: _openPlayer),
      AccountScreen(
        subscribed: _isSubscribed,
        extraUnlocked: _extraUnlocked,
        onAdmin: _openAdmin,
        onPlan: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => SubscriptionScreen(
              subscribed: _isSubscribed,
              onSubscribe: () => setState(() => _isSubscribed = true),
            ),
          ),
        ),
        onExtra: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => ExtraScreen(
              unlocked: _extraUnlocked,
              onPlay: _openPlayer,
              onUnlock: () => setState(() => _extraUnlocked = true),
            ),
          ),
        ),
        onSignOut: () => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute<void>(builder: (_) => const AuthScreen()),
          (_) => false,
        ),
      ),
    ];

    return Scaffold(
      body: isWide
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: _tab,
                  onDestinationSelected: (index) =>
                      setState(() => _tab = index),
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home_rounded),
                      label: Text('Inicio'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.explore_outlined),
                      selectedIcon: Icon(Icons.explore_rounded),
                      label: Text('Explorar'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: Text('Cuenta'),
                    ),
                  ],
                ),
                const VerticalDivider(width: 1, color: _line),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 960),
                      child: IndexedStack(index: _tab, children: pages),
                    ),
                  ),
                ),
              ],
            )
          : IndexedStack(index: _tab, children: pages),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_hasCurrentAudio)
            _MiniPlayer(
              audio: _currentAudio,
              isPlaying: _isPlaying,
              onTap: _openPlayer,
              onToggle: () => setState(() => _isPlaying = !_isPlaying),
            ),
          if (!isWide)
            NavigationBar(
              selectedIndex: _tab,
              onDestinationSelected: (index) => setState(() => _tab = index),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'Inicio',
                ),
                NavigationDestination(
                  icon: Icon(Icons.explore_outlined),
                  selectedIcon: Icon(Icons.explore_rounded),
                  label: 'Explorar',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Cuenta',
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.onPlay,
    required this.onBrowseCategory,
    required this.onBrowseAll,
    required this.onOpenExtra,
    required this.onOpenPlan,
    super.key,
  });

  final ValueChanged<AudioItem> onPlay;
  final ValueChanged<String> onBrowseCategory;
  final VoidCallback onBrowseAll;
  final VoidCallback onOpenExtra;
  final VoidCallback onOpenPlan;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  children: [
                    const _BrandMark(compact: true),
                    const Spacer(),
                    IconButton(
                      tooltip: 'Cuenta',
                      onPressed: onOpenPlan,
                      icon: const Icon(Icons.notifications_none_rounded),
                    ),
                    const CircleAvatar(
                      radius: 19,
                      backgroundColor: Color(0xFFE5EDE7),
                      child: Icon(Icons.person_outline, color: _green),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Hola, qué gusto verte',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                _TrialBanner(onTap: onOpenPlan),
                const SizedBox(height: 28),
                _SectionHeading(
                  title: 'Explorar por categoría',
                  action: 'Ver todas',
                  onAction: onBrowseAll,
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 46,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _CategoryChip(
                        label: 'Bienestar',
                        selected: true,
                        onTap: () => onBrowseCategory('Bienestar'),
                      ),
                      _CategoryChip(
                        label: 'Descanso',
                        onTap: () => onBrowseCategory('Descanso'),
                      ),
                      _CategoryChip(
                        label: 'Enfoque',
                        onTap: () => onBrowseCategory('Enfoque'),
                      ),
                      _CategoryChip(
                        label: 'Pausas',
                        onTap: () => onBrowseCategory('Pausas'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                const _SectionHeading(title: 'Audio destacado'),
                const SizedBox(height: 14),
                _FeaturedAudioCard(audio: _audios.first, onPlay: onPlay),
                const SizedBox(height: 28),
                _ExtraBanner(onTap: onOpenExtra),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({required this.onPlay, super.key});

  final ValueChanged<AudioItem> onPlay;

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _query = '';
  String _category = 'Todas';

  @override
  Widget build(BuildContext context) {
    final categories = ['Todas', 'Bienestar', 'Descanso', 'Enfoque', 'Pausas'];
    final results = _audios.where((audio) {
      final matchesText =
          audio.title.toLowerCase().contains(_query.toLowerCase());
      final matchesCategory =
          _category == 'Todas' || audio.category == _category;
      return matchesText && matchesCategory;
    }).toList();

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  'Explorar',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 18),
                TextField(
                  onChanged: (value) => setState(() => _query = value),
                  decoration: const InputDecoration(
                    hintText: 'Buscar audios',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Categorías',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 46,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: categories
                        .map(
                          (category) => _CategoryChip(
                            label: category,
                            selected: _category == category,
                            onTap: () => setState(() => _category = category),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  '${results.length} audios',
                  style: const TextStyle(
                    color: _muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
              ]),
            ),
          ),
          if (results.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text('No encontramos audios')),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _AudioListTile(
                      audio: results[index],
                      onTap: () => _openAudio(context, results[index]),
                    ),
                  ),
                  childCount: results.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _openAudio(BuildContext context, AudioItem audio) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AudioDetailScreen(audio: audio, onPlay: widget.onPlay),
      ),
    );
  }
}

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({
    required this.category,
    required this.onPlay,
    super.key,
  });

  final String category;
  final ValueChanged<AudioItem> onPlay;

  @override
  Widget build(BuildContext context) {
    final audios = _audios.where((audio) => audio.category == category).toList();

    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: audios.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final audio = audios[index];
          return _AudioListTile(
            audio: audio,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) =>
                    AudioDetailScreen(audio: audio, onPlay: onPlay),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AudioDetailScreen extends StatelessWidget {
  const AudioDetailScreen({
    required this.audio,
    required this.onPlay,
    super.key,
  });

  final AudioItem audio;
  final ValueChanged<AudioItem> onPlay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
          children: [
            Center(child: _Artwork(color: audio.artworkColor, size: 250)),
            const SizedBox(height: 28),
            Text(
              audio.title,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              '${audio.category} · ${audio.duration}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: _muted),
            ),
            const SizedBox(height: 26),
            const Text(
              'Acerca de este audio',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              audio.description,
              style: const TextStyle(color: _muted, height: 1.5),
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: () => onPlay(audio),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Reproducir audio'),
              style: FilledButton.styleFrom(
                backgroundColor: _green,
                minimumSize: const Size.fromHeight(54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountScreen extends StatelessWidget {
  const AccountScreen({
    required this.subscribed,
    required this.extraUnlocked,
    required this.onAdmin,
    required this.onPlan,
    required this.onExtra,
    required this.onSignOut,
    super.key,
  });

  final bool subscribed;
  final bool extraUnlocked;
  final VoidCallback onAdmin;
  final VoidCallback onPlan;
  final VoidCallback onExtra;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
        children: [
          Text(
            'Cuenta',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 24),
          const Card(
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: CircleAvatar(
                radius: 27,
                backgroundColor: Color(0xFFE5EDE7),
                child: Icon(Icons.person_outline, color: _green),
              ),
              title: Text('Usuario de ejemplo'),
              subtitle: Text('correo@ejemplo.com'),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Tu acceso',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: const Icon(Icons.hourglass_bottom, color: _green),
              title: Text(subscribed ? 'Suscripción mensual' : 'Prueba gratis'),
              subtitle: Text(
                subscribed ? 'Acceso activo' : 'Termina en 7 días',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: onPlan,
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.auto_awesome_outlined, color: _green),
              title: const Text('Apartado extra'),
              subtitle: Text(extraUnlocked ? 'Desbloqueado' : 'Pago único'),
              trailing: const Icon(Icons.chevron_right),
              onTap: onExtra,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Preferencias',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          _AccountAction(
            icon: Icons.restore_rounded,
            title: 'Restaurar compras',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('La restauración estará disponible al integrar pagos.'),
              ),
            ),
          ),
          _AccountAction(
            icon: Icons.admin_panel_settings_outlined,
            title: 'Panel de administración (demo)',
            onTap: onAdmin,
          ),
          _AccountAction(
            icon: Icons.logout,
            title: 'Cerrar sesión',
            onTap: onSignOut,
          ),
        ],
      ),
    );
  }
}

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({
    required this.audio,
    required this.isPlaying,
    required this.onPlayingChanged,
    super.key,
  });

  final AudioItem audio;
  final bool isPlaying;
  final ValueChanged<bool> onPlayingChanged;

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late bool _playing;
  bool _repeat = false;

  @override
  void initState() {
    super.initState();
    _playing = widget.isPlaying;
  }

  void _setPlaying(bool value) {
    setState(() => _playing = value);
    widget.onPlayingChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final artworkSize = (size.width - 56)
        .clamp(0.0, size.height * .34)
        .clamp(0.0, 280.0)
        .toDouble();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Minimizar reproductor',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
        ),
        title: const Text('Reproduciendo'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 12, 28, 28),
          child: Column(
            children: [
              _Artwork(color: widget.audio.artworkColor, size: artworkSize),
              const SizedBox(height: 28),
              Text(
                widget.audio.title,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(widget.audio.category,
                  style: const TextStyle(color: _muted, fontSize: 16)),
              const SizedBox(height: 30),
              Slider(
                value: .22,
                onChanged: (_) {},
                activeColor: _green,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('02:15', style: TextStyle(color: _muted, fontSize: 12)),
                  Text('12:40', style: TextStyle(color: _muted, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    tooltip: 'Retroceder 15 segundos',
                    onPressed: () {},
                    icon: const Icon(Icons.replay_10_rounded, size: 34),
                  ),
                  IconButton.filled(
                    tooltip: _playing ? 'Pausar' : 'Reproducir',
                    onPressed: () => _setPlaying(!_playing),
                    style: IconButton.styleFrom(
                      backgroundColor: _green,
                      minimumSize: const Size(68, 68),
                    ),
                    icon: Icon(
                      _playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      size: 38,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Avanzar 30 segundos',
                    onPressed: () {},
                    icon: const Icon(Icons.forward_30_rounded, size: 34),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () => setState(() => _repeat = !_repeat),
                icon: Icon(
                  Icons.repeat_rounded,
                  color: _repeat ? _green : _muted,
                ),
                label: Text(
                  _repeat ? 'Repetición activada' : 'Repetir',
                  style: TextStyle(color: _repeat ? _green : _muted),
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Interfaz de demostración: el audio y los controles en segundo plano aún no están conectados.',
                textAlign: TextAlign.center,
                style: TextStyle(color: _muted, fontSize: 12, height: 1.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({
    required this.subscribed,
    required this.onSubscribe,
    super.key,
  });

  final bool subscribed;
  final VoidCallback onSubscribe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acceso principal')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _IllustrationIcon(
                  icon: Icons.headphones_rounded,
                  color: Color(0xFFE5EDE7),
                ),
                const SizedBox(height: 24),
                Text(
                  subscribed ? 'Tu acceso está activo' : 'Prueba gratis por 7 días',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                Text(
                  subscribed
                      ? 'Puedes seguir disfrutando de la biblioteca de audios.'
                      : 'Al terminar la prueba, elige si quieres contratar el acceso mensual. No se te cobrará automáticamente.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: _muted, height: 1.5),
                ),
                const SizedBox(height: 24),
                const _InfoTile(
                  icon: Icons.library_music_outlined,
                  title: 'Acceso a la biblioteca',
                  subtitle: 'Escucha los audios disponibles las veces que quieras.',
                ),
                const _InfoTile(
                  icon: Icons.autorenew,
                  title: 'Suscripción mensual',
                  subtitle: 'El precio se mostrará antes de confirmar la compra.',
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: subscribed
                      ? null
                      : () {
                          onSubscribe();
                          Navigator.of(context).pop();
                        },
                  style: FilledButton.styleFrom(
                    backgroundColor: _green,
                    minimumSize: const Size.fromHeight(54),
                  ),
                  child: Text(
                    subscribed ? 'Suscripción activa' : 'Continuar con suscripción',
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Compra simulada para el prototipo. Los pagos reales deben integrarse y validarse mediante las tiendas y el servidor.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _muted, fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ExtraScreen extends StatelessWidget {
  const ExtraScreen({
    required this.unlocked,
    required this.onPlay,
    required this.onUnlock,
    super.key,
  });

  final bool unlocked;
  final ValueChanged<AudioItem> onPlay;
  final VoidCallback onUnlock;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Apartado extra')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _IllustrationIcon(
                  icon: Icons.auto_awesome_rounded,
                  color: Color(0xFFEDE5D9),
                ),
                const SizedBox(height: 24),
                Text(
                  unlocked ? 'Apartado desbloqueado' : 'Contenido adicional',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Un espacio independiente con audios y recursos adicionales.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _muted, height: 1.5),
                ),
                const SizedBox(height: 24),
                if (unlocked)
                  ..._audios.take(2).map(
                        (audio) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _AudioListTile(
                            audio: audio,
                            onTap: () => onPlay(audio),
                          ),
                        ),
                      )
                else ...[
                  const _InfoTile(
                    icon: Icons.shopping_bag_outlined,
                    title: 'Pago único',
                    subtitle: 'El costo se mostrará antes de confirmar la compra.',
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      onUnlock();
                      Navigator.of(context).pop();
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: _green,
                      minimumSize: const Size.fromHeight(54),
                    ),
                    child: const Text('Desbloquear apartado'),
                  ),
                ],
                const SizedBox(height: 16),
                const Text(
                  'Compra simulada para el prototipo. La compra real se conectará a la plataforma correspondiente.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _muted, fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Administración · demo')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const _AudioFormScreen(),
          ),
        ),
        backgroundColor: _green,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.upload_file),
        label: const Text('Subir audio'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Gestiona audios y categorías. En la versión conectada, esta sección solo estará disponible para administradores.',
            style: TextStyle(color: _muted, height: 1.5),
          ),
          const SizedBox(height: 20),
          const _SectionHeading(title: 'Audios publicados'),
          const SizedBox(height: 12),
          ..._audios.map(
            (audio) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _AudioListTile(
                audio: audio,
                trailing: IconButton(
                  tooltip: 'Editar audio',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => _AudioFormScreen(audio: audio),
                    ),
                  ),
                  icon: const Icon(Icons.edit_outlined),
                ),
                onTap: () {},
              ),
            ),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Gestión de categorías pendiente de conexión.'),
              ),
            ),
            icon: const Icon(Icons.category_outlined),
            label: const Text('Gestionar categorías'),
          ),
        ],
      ),
    );
  }
}

class _AudioFormScreen extends StatelessWidget {
  const _AudioFormScreen({this.audio});

  final AudioItem? audio;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(audio == null ? 'Nuevo audio' : 'Editar audio')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          OutlinedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('La selección de archivos estará disponible al integrar Storage.'),
              ),
            ),
            icon: const Icon(Icons.audio_file_outlined),
            label: const Text('Seleccionar archivo de audio'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(58),
            ),
          ),
          const SizedBox(height: 18),
          TextFormField(
            initialValue: audio?.title,
            decoration: const InputDecoration(labelText: 'Título'),
          ),
          const SizedBox(height: 14),
          TextFormField(
            initialValue: audio?.description,
            maxLines: 4,
            decoration: const InputDecoration(labelText: 'Descripción'),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            value: audio?.category ?? 'Bienestar',
            decoration: const InputDecoration(labelText: 'Categoría'),
            items: const ['Bienestar', 'Descanso', 'Enfoque', 'Pausas']
                .map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ))
                .toList(),
            onChanged: (_) {},
          ),
          const SizedBox(height: 14),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Publicado'),
            value: true,
            onChanged: (_) {},
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            style: FilledButton.styleFrom(
              backgroundColor: _green,
              minimumSize: const Size.fromHeight(54),
            ),
            child: const Text('Guardar cambios'),
          ),
        ],
      ),
    );
  }
}

class _MiniPlayer extends StatelessWidget {
  const _MiniPlayer({
    required this.audio,
    required this.isPlaying,
    required this.onTap,
    required this.onToggle,
  });

  final AudioItem audio;
  final bool isPlaying;
  final VoidCallback onTap;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
          child: Row(
            children: [
              _Artwork(color: audio.artworkColor, size: 42),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(audio.title,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(audio.category,
                        style: const TextStyle(color: _muted, fontSize: 12)),
                  ],
                ),
              ),
              IconButton(
                tooltip: isPlaying ? 'Pausar' : 'Reproducir',
                onPressed: onToggle,
                icon: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturedAudioCard extends StatelessWidget {
  const _FeaturedAudioCard({required this.audio, required this.onPlay});

  final AudioItem audio;
  final ValueChanged<AudioItem> onPlay;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 158,
            child: ColoredBox(
              color: audio.artworkColor,
              child: const Icon(
                Icons.spa_outlined,
                size: 64,
                color: _green,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(audio.category,
                    style: const TextStyle(color: _green, fontSize: 13)),
                const SizedBox(height: 5),
                Text(
                  audio.title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                FilledButton.icon(
                  onPressed: () => onPlay(audio),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Escuchar'),
                  style: FilledButton.styleFrom(
                    backgroundColor: _green,
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AudioListTile extends StatelessWidget {
  const _AudioListTile({
    required this.audio,
    required this.onTap,
    this.trailing,
  });

  final AudioItem audio;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        leading: _Artwork(color: audio.artworkColor, size: 52),
        title: Text(audio.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text('${audio.category} · ${audio.duration}'),
        trailing: trailing ??
            IconButton(
              tooltip: 'Reproducir ${audio.title}',
              onPressed: onTap,
              icon: const Icon(Icons.play_circle_outline_rounded, size: 30),
            ),
        onTap: onTap,
      ),
    );
  }
}

class _TrialBanner extends StatelessWidget {
  const _TrialBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFE8EFEA),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.hourglass_bottom, color: _green),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tu prueba gratis está activa',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    SizedBox(height: 3),
                    Text('Quedan 7 días',
                        style: TextStyle(color: _muted, fontSize: 13)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: _green),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExtraBanner extends StatelessWidget {
  const _ExtraBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFEDE5D9),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(18),
          child: Row(
            children: [
              Icon(Icons.auto_awesome_outlined, color: _green, size: 28),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Apartado extra',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    SizedBox(height: 3),
                    Text('Contenido adicional · Pago único',
                        style: TextStyle(color: _muted, fontSize: 13)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: _green),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: onTap == null ? null : (_) => onTap!(),
        selectedColor: const Color(0xFFE1EBE4),
        labelStyle: TextStyle(
          color: selected ? _green : _muted,
          fontWeight: FontWeight.w600,
        ),
        side: BorderSide(color: selected ? const Color(0xFFE1EBE4) : _line),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.title,
    this.action,
    this.onAction,
  });

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
        ),
        if (action != null)
          TextButton(onPressed: onAction, child: Text(action!)),
      ],
    );
  }
}

class _AccountAction extends StatelessWidget {
  const _AccountAction({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: _muted),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: _muted),
      onTap: onTap,
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: ListTile(
          leading: Icon(icon, color: _green),
          title: Text(title),
          subtitle: Text(subtitle),
        ),
      ),
    );
  }
}

class _Artwork extends StatelessWidget {
  const _Artwork({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size * .12),
      ),
      child: Icon(
        Icons.graphic_eq_rounded,
        color: _green,
        size: size * .35,
      ),
    );
  }
}

class _IllustrationIcon extends StatelessWidget {
  const _IllustrationIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(
        radius: 56,
        backgroundColor: color,
        child: Icon(icon, color: _green, size: 50),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 38 : 54,
          height: compact ? 38 : 54,
          decoration: BoxDecoration(
            color: const Color(0xFFE5EDE7),
            borderRadius: BorderRadius.circular(compact ? 13 : 18),
          ),
          child: Icon(
            Icons.graphic_eq_rounded,
            color: _green,
            size: compact ? 23 : 32,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'Nombre provisional',
          style: TextStyle(
            color: _ink,
            fontSize: compact ? 16 : 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
