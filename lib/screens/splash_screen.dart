import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class ChessMove {
  final int fromRow;
  final int fromCol;
  final int toRow;
  final int toCol;
  final String piece;
  final String notation;
  final String commentary;
  final int? fromRow2;
  final int? fromCol2;
  final int? toRow2;
  final int? toCol2;
  final String? piece2;

  const ChessMove({
    required this.fromRow,
    required this.fromCol,
    required this.toRow,
    required this.toCol,
    required this.piece,
    required this.notation,
    required this.commentary,
    this.fromRow2,
    this.fromCol2,
    this.toRow2,
    this.toCol2,
    this.piece2,
  });
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  double _progress = 0.0;
  final List<String> _logs = [];
  final ScrollController _logScrollController = ScrollController();
  late Timer _progressTimer;
  late Timer _chessTimer;
  bool _isTransitioning = false;

  // 8x8 Chess Board State
  late List<List<String>> _board;
  int _currentMoveIndex = 0;
  int? _highlightFromRow;
  int? _highlightFromCol;
  int? _highlightToRow;
  int? _highlightToCol;

  final List<ChessMove> _simulatedMoves = const [
    ChessMove(fromRow: 6, fromCol: 4, toRow: 4, toCol: 4, piece: 'P', notation: '1. e4', commentary: 'White opens with King\'s Pawn Game.'),
    ChessMove(fromRow: 1, fromCol: 4, toRow: 3, toCol: 4, piece: 'p', notation: '1... e5', commentary: 'Black responds symmetrically.'),
    ChessMove(fromRow: 7, fromCol: 6, toRow: 5, toCol: 5, piece: 'N', notation: '2. Nf3', commentary: 'White attacks black pawn on e5.'),
    ChessMove(fromRow: 0, fromCol: 1, toRow: 2, toCol: 2, piece: 'n', notation: '2... Nc6', commentary: 'Black defends pawn & develops Knight.'),
    ChessMove(fromRow: 7, fromCol: 5, toRow: 3, toCol: 1, piece: 'B', notation: '3. Bb5', commentary: 'Ruy Lopez: White pressures Black\'s Knight.'),
    ChessMove(fromRow: 1, fromCol: 0, toRow: 2, toCol: 0, piece: 'p', notation: '3... a6', commentary: 'Morphy Defence: Black questions the Bishop.'),
    ChessMove(fromRow: 3, fromCol: 1, toRow: 4, toCol: 0, piece: 'B', notation: '4. Ba4', commentary: 'White maintains pressure but retreats.'),
    ChessMove(fromRow: 0, fromCol: 6, toRow: 2, toCol: 5, piece: 'n', notation: '4... Nf6', commentary: 'Black develops Knight, targeting e4.'),
    ChessMove(
      fromRow: 7, fromCol: 4, toRow: 7, toCol: 6, piece: 'K',
      fromRow2: 7, fromCol2: 7, toRow2: 7, toCol2: 5, piece2: 'R',
      notation: '5. O-O', commentary: 'White castles kingside. King is secured.'
    ),
    ChessMove(fromRow: 2, fromCol: 5, toRow: 4, toCol: 4, piece: 'n', notation: '5... Nxe4', commentary: 'Open Ruy Lopez: Black takes the e4 pawn.'),
    ChessMove(fromRow: 6, fromCol: 3, toRow: 4, toCol: 3, piece: 'P', notation: '6. d4', commentary: 'White strikes back in the center.'),
    ChessMove(fromRow: 1, fromCol: 1, toRow: 3, toCol: 1, piece: 'p', notation: '6... b5', commentary: 'Black drives the Bishop further back.'),
    ChessMove(fromRow: 4, fromCol: 0, toRow: 5, toCol: 2, piece: 'B', notation: '7. Bb3', commentary: 'Bishop retreats to active diagonal.'),
    ChessMove(fromRow: 1, fromCol: 3, toRow: 3, toCol: 3, piece: 'p', notation: '7... d5', commentary: 'Black solidifies center space.'),
    ChessMove(fromRow: 4, fromCol: 3, toRow: 3, toCol: 4, piece: 'P', notation: '8. dxe5', commentary: 'White regains pawn material parity.'),
    ChessMove(fromRow: 0, fromCol: 2, toRow: 2, toCol: 4, piece: 'b', notation: '8... Be6', commentary: 'Black supports d5 pawn & develops Bishop.'),
  ];

  final List<String> _bootLogs = [
    "SYS_BOOT: Initiating Vivek OS v3.5...",
    "SYS_NET: Resolving portfolio DNS entries...",
    "SYS_NET: Ping to secure mainframe: 12ms",
    "SYS_MEM: Caching asset files (8.4 MB)...",
    "SYS_ASSETS: Video controllers registered.",
    "CHESS_ENG: Launching Stockfish evaluation node...",
    "CHESS_ENG: Active search depth 18. Threads 4.",
    "PORTFOLIO: Loading HeroSection component...",
    "PORTFOLIO: Loading AboutSection component...",
    "PORTFOLIO: Loading SkillsSection component...",
    "PORTFOLIO: Loading ExperienceSection component...",
    "PORTFOLIO: Loading ProjectsSection component...",
    "PORTFOLIO: Loading LifestyleSection component...",
    "PORTFOLIO: Loading TestimonialsSection component...",
    "PORTFOLIO: Loading ContactSection component...",
    "SYS_CALIBRATE: Synchronizing eye-tracking vectors...",
    "SYS_CALIBRATE: Parallax backgrounds loaded.",
    "SYS_READY: Startup diagnostics succeeded.",
    "SEC_HANDSHAKE: Tunnel established [SSL/TLS 1.3].",
    "ACCESS: Authorizing terminal user..."
  ];

  int _bootLogIndex = 0;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _resetBoard();
    _startLoading();
  }

  void _resetBoard() {
    _board = [
      ['r', 'n', 'b', 'q', 'k', 'b', 'n', 'r'],
      ['p', 'p', 'p', 'p', 'p', 'p', 'p', 'p'],
      ['', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', ''],
      ['P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'],
      ['R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R'],
    ];
    _currentMoveIndex = 0;
    _highlightFromRow = null;
    _highlightFromCol = null;
    _highlightToRow = null;
    _highlightToCol = null;
  }

  void _startLoading() {
    _addLog("SYSTEM: Initializing bootloader...");

    // Progress updates organically every 80ms
    _progressTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
      if (_progress >= 1.0) {
        timer.cancel();
        _onLoadingCompleted();
      } else {
        setState(() {
          double increment = _random.nextDouble() * 0.02 + 0.005;
          _progress = min(_progress + increment, 1.0);
        });

        // Periodically inject boot logs based on progress thresholds
        int targetLogCount = ((_progress * 1.5) * _bootLogs.length).floor();
        while (_bootLogIndex < targetLogCount && _bootLogIndex < _bootLogs.length) {
          _addLog(_bootLogs[_bootLogIndex]);
          _bootLogIndex++;
        }
      }
    });

    // Chess moves execute every 700ms
    _chessTimer = Timer.periodic(const Duration(milliseconds: 700), (timer) {
      if (_currentMoveIndex < _simulatedMoves.length) {
        _makeSimulatedMove(_simulatedMoves[_currentMoveIndex]);
        _currentMoveIndex++;
      } else {
        // If we ran out of moves, reset board and repeat
        _resetBoard();
      }
    });
  }

  void _makeSimulatedMove(ChessMove move) {
    setState(() {
      // Set highlights
      _highlightFromRow = move.fromRow;
      _highlightFromCol = move.fromCol;
      _highlightToRow = move.toRow;
      _highlightToCol = move.toCol;

      // Update basic piece position
      _board[move.toRow][move.toCol] = move.piece;
      _board[move.fromRow][move.fromCol] = '';

      // Handle castling rook
      if (move.fromRow2 != null && move.fromCol2 != null && move.toRow2 != null && move.toCol2 != null) {
        _board[move.toRow2!][move.toCol2!] = move.piece2!;
        _board[move.fromRow2!][move.fromCol2!] = '';
      }
    });

    // Add chess move logs to the terminal
    _addLog("[CHESS] ${move.notation} - ${move.commentary}");
  }

  void _addLog(String log) {
    if (mounted) {
      setState(() {
        _logs.add(log);
      });
      // Scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_logScrollController.hasClients) {
          _logScrollController.animateTo(
            _logScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _onLoadingCompleted() {
    _addLog("SYSTEM: Launch sequence armed. Ready to enter.");
    // Automatically transition to the portfolio home after 1.5 seconds if we haven't already transitioned
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted && !_isTransitioning) {
        _launchPortfolio();
      }
    });
  }

  void _launchPortfolio() {
    if (_isTransitioning) return;
    _isTransitioning = true;
    _progressTimer.cancel();
    _chessTimer.cancel();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 1.08, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
              ),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 1100),
      ),
    );
  }

  @override
  void dispose() {
    _progressTimer.cancel();
    _chessTimer.cancel();
    _logScrollController.dispose();
    super.dispose();
  }

  String _getPieceUnicode(String piece) {
    switch (piece.toLowerCase()) {
      case 'p': return '♟';
      case 'r': return '♜';
      case 'n': return '♞';
      case 'b': return '♝';
      case 'q': return '♛';
      case 'k': return '♚';
      default: return '';
    }
  }

  Color _getPieceColor(String piece) {
    bool isWhite = piece == piece.toUpperCase();
    return isWhite ? AppTheme.neon : AppTheme.purple;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 800;

    return Scaffold(
      backgroundColor: const Color(0xFF060608),
      body: SafeArea(
        child: Stack(
          children: [
            // Cyber scanlines background effect
            Positioned.fill(
              child: Opacity(
                opacity: 0.03,
                child: CustomPaint(
                  painter: _ScanlinePainter(),
                ),
              ),
            ),

            // Top Header & Skip Button
            Positioned(
              top: 16,
              left: 24,
              right: 24,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppTheme.neon,
                          shape: BoxShape.circle,
                        ),
                      ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                       .scale(end: const Offset(1.5, 1.5), duration: 800.ms),
                      const SizedBox(width: 10),
                      Text(
                        "VIVEK_CORE_OS : STABLE",
                        style: GoogleFonts.shareTechMono(
                          color: AppTheme.neon,
                          fontSize: 14,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: _launchPortfolio,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white.withOpacity(0.5),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      side: BorderSide(color: Colors.white.withOpacity(0.15)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text(
                      "SKIP INTRO >|",
                      style: GoogleFonts.shareTechMono(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            // Main Contents (split/stacked)
            Positioned.fill(
              top: 70,
              bottom: 120,
              left: 20,
              right: 20,
              child: isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Left Console
                        Expanded(
                          flex: 5,
                          child: _buildConsoleCard(),
                        ),
                        const SizedBox(width: 24),
                        // Right Chess
                        Expanded(
                          flex: 4,
                          child: _buildChessCard(),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        // Top Chess
                        Expanded(
                          flex: 11,
                          child: _buildChessCard(),
                        ),
                        const SizedBox(height: 16),
                        // Bottom Console
                        Expanded(
                          flex: 10,
                          child: _buildConsoleCard(),
                        ),
                      ],
                    ),
            ),

            // Bottom loading bar
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _progress >= 1.0 ? "BOOT_COMPLETE: SYSTEM ENGAGED" : "INITIALIZING CORE MEMORY VECTOR...",
                        style: GoogleFonts.shareTechMono(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        "${(_progress * 100).toInt()}%",
                        style: GoogleFonts.shareTechMono(
                          color: AppTheme.neon,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Progress Track
                  Container(
                    height: 10,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Stack(
                      children: [
                        FractionallySizedBox(
                          widthFactor: _progress,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppTheme.purple, AppTheme.neon],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.neon.withOpacity(0.3),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Flashing Access Button
                  Center(
                    child: AnimatedOpacity(
                      opacity: _progress >= 1.0 ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: IgnorePointer(
                        ignoring: _progress < 1.0,
                        child: TextButton(
                          onPressed: _launchPortfolio,
                          style: TextButton.styleFrom(
                            backgroundColor: AppTheme.neon,
                            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                            shape: const BeveledRectangleBorder(
                              side: BorderSide(color: AppTheme.neon, width: 1.5),
                            ),
                          ),
                          child: Text(
                            "ENTER PORTFOLIO",
                            style: GoogleFonts.shareTechMono(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 3.0,
                            ),
                          ),
                        )
                            .animate(onPlay: (controller) => controller.repeat())
                            .shimmer(delay: 500.ms, duration: 1500.ms, color: Colors.white.withOpacity(0.5)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsoleCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0C0C10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.neon.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.neon.withOpacity(0.02),
            blurRadius: 12,
            spreadRadius: 2,
          )
        ],
      ),
      child: Stack(
        children: [
          // Cyberpunk Grid Pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.015,
              child: CustomPaint(
                painter: _GridPainter(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "CONSOLE // LOG_DIAGNOSTICS",
                      style: GoogleFonts.shareTechMono(
                        color: AppTheme.neon,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const Divider(color: Color(0xFF22222A), height: 16),
                Expanded(
                  child: ListView.builder(
                    controller: _logScrollController,
                    itemCount: _logs.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _logs.length) {
                        // Flashing Cursor line
                        return Row(
                          children: [
                            Text(
                              "> ",
                              style: GoogleFonts.shareTechMono(
                                color: AppTheme.neon,
                                fontSize: 13,
                              ),
                            ),
                            Container(
                              width: 8,
                              height: 13,
                              color: AppTheme.neon,
                            )
                                .animate(onPlay: (controller) => controller.repeat(reverse: true))
                                .fadeIn(duration: 400.ms)
                                .fadeOut(duration: 400.ms),
                          ],
                        );
                      }
                      final log = _logs[index];
                      Color logColor = Colors.white.withOpacity(0.85);
                      if (log.startsWith("SYS_BOOT") || log.startsWith("SYSTEM")) {
                        logColor = AppTheme.neon;
                      } else if (log.startsWith("[CHESS]")) {
                        logColor = AppTheme.purple.withAlpha(220);
                      } else if (log.contains("SUCCESS") || log.contains("stable") || log.contains("complete")) {
                        logColor = Colors.greenAccent;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Text(
                          log,
                          style: GoogleFonts.shareTechMono(
                            color: logColor,
                            fontSize: 12.5,
                            height: 1.3,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChessCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0C0C10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.purple.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.purple.withOpacity(0.02),
            blurRadius: 12,
            spreadRadius: 2,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "CHESS_MATRIX // DISPLAY",
                  style: GoogleFonts.shareTechMono(
                    color: AppTheme.purple,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "STOCKFISH v16.1",
                  style: GoogleFonts.shareTechMono(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const Divider(color: Color(0xFF22222A), height: 16),
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white.withOpacity(0.1), width: 2),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final cellSize = constraints.maxWidth / 8;
                        return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 64,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 8,
                          ),
                          itemBuilder: (context, index) {
                            final row = index ~/ 8;
                            final col = index % 8;
                            final isDarkSquare = (row + col) % 2 == 1;
                            final piece = _board[row][col];

                            // Check if this square is highlighted as part of the last move
                            final isHighlighted = (row == _highlightFromRow && col == _highlightFromCol) ||
                                                   (row == _highlightToRow && col == _highlightToCol);

                            Color squareColor = isDarkSquare
                                ? Colors.white.withOpacity(0.02)
                                : Colors.white.withOpacity(0.06);

                            if (isHighlighted) {
                              // Highlight moves with gradient border or semi-transparent overlay
                              squareColor = (row == _highlightToRow && col == _highlightToCol)
                                  ? AppTheme.neon.withOpacity(0.12)
                                  : AppTheme.purple.withOpacity(0.12);
                            }

                            return Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: squareColor,
                                border: isHighlighted
                                    ? Border.all(
                                        color: (row == _highlightToRow && col == _highlightToCol)
                                            ? AppTheme.neon.withOpacity(0.6)
                                            : AppTheme.purple.withOpacity(0.6),
                                        width: 1.5,
                                      )
                                    : Border.all(color: Colors.white.withOpacity(0.015), width: 0.5),
                              ),
                              child: piece.isNotEmpty
                                  ? Text(
                                      _getPieceUnicode(piece),
                                      style: TextStyle(
                                        color: _getPieceColor(piece),
                                        fontSize: cellSize * 0.65,
                                      ),
                                    )
                                      .animate(target: isHighlighted ? 1.0 : 0.0)
                                      .scale(
                                        begin: const Offset(1.0, 1.0),
                                        end: const Offset(1.15, 1.15),
                                        duration: 250.ms,
                                        curve: Curves.easeOut,
                                      )
                                  : null,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter for retro scanning line background effect
class _ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..strokeWidth = 1.0;

    for (double y = 0; y < size.height; y += 4.0) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom Painter for Cyber Card Grid lines
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 0.5;

    const double step = 20.0;

    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
