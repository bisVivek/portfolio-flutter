import 'dart:async';
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
  bool _isTransitioning = false;

  // 8x8 Chess Board State
  late List<List<String>> _board;
  int? _highlightFromRow;
  int? _highlightFromCol;
  int? _highlightToRow;
  int? _highlightToCol;

  int? _selectedRow;
  int? _selectedCol;
  int _puzzleStep = 0;
  bool _hintActive = false;
  String? _firstMovePiece;

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

  @override
  void initState() {
    super.initState();
    _resetBoard();
    _startLoading();
  }

  void _resetBoard() {
    _board = [
      ['r', '', '', 'r', '', '', 'k', ''],
      ['', '', '', '', '', 'p', 'p', 'p'],
      ['', '', '', '', '', '', '', ''],
      ['Q', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', ''],
      ['', '', '', '', '', 'P', 'P', 'P'],
      ['', '', '', 'R', '', '', 'K', ''],
    ];
    _selectedRow = null;
    _selectedCol = null;
    _puzzleStep = 0;
    _hintActive = false;
    _firstMovePiece = null;
    _progress = 0.2;
    _highlightFromRow = null;
    _highlightFromCol = null;
    _highlightToRow = null;
    _highlightToCol = null;
  }

  void _startLoading() {
    _addLog("SYSTEM: Initializing bootloader...");
    _bootLogIndex = 0;
    _progress = 0.0;

    // Fast initial boot log print
    _progressTimer = Timer.periodic(const Duration(milliseconds: 60), (timer) {
      if (_bootLogIndex < _bootLogs.length) {
        _addLog(_bootLogs[_bootLogIndex]);
        _bootLogIndex++;
        setState(() {
          _progress = 0.05 + 0.15 * (_bootLogIndex / _bootLogs.length);
        });
      } else {
        timer.cancel();
        _addLog("SYSTEM: Security challenge active: Back Rank Deflection.");
        _addLog("SYSTEM: White to move and checkmate in 2 moves.");
        _addLog("SYSTEM: Tap a white piece and tap its target square to move.");
        setState(() {
          _progress = 0.2;
        });
      }
    });
  }

  void _onSquareTap(int row, int col) {
    if (_isTransitioning || _puzzleStep >= 2) return;

    final clickedPiece = _board[row][col];
    final isWhitePiece = clickedPiece.isNotEmpty && clickedPiece == clickedPiece.toUpperCase();

    if (_selectedRow == null || _selectedCol == null) {
      if (isWhitePiece) {
        setState(() {
          _selectedRow = row;
          _selectedCol = col;
          _hintActive = false;
        });
        _addLog("PLAYER: Selected ${_getPieceName(clickedPiece)} at ${_getCoordinatesNotation(row, col)}");
      }
    } else {
      final fromRow = _selectedRow!;
      final fromCol = _selectedCol!;

      if (row == fromRow && col == fromCol) {
        setState(() {
          _selectedRow = null;
          _selectedCol = null;
        });
        return;
      }

      if (isWhitePiece) {
        setState(() {
          _selectedRow = row;
          _selectedCol = col;
        });
        _addLog("PLAYER: Selected ${_getPieceName(clickedPiece)} at ${_getCoordinatesNotation(row, col)}");
        return;
      }

      _makePlayerMove(fromRow, fromCol, row, col);
    }
  }

  String _getPieceName(String piece) {
    switch (piece.toUpperCase()) {
      case 'K': return 'King';
      case 'Q': return 'Queen';
      case 'R': return 'Rook';
      case 'B': return 'Bishop';
      case 'N': return 'Knight';
      case 'P': return 'Pawn';
      default: return 'Piece';
    }
  }

  void _makePlayerMove(int fromRow, int fromCol, int toRow, int toCol) {
    final fromNotation = _getCoordinatesNotation(fromRow, fromCol);
    final toNotation = _getCoordinatesNotation(toRow, toCol);
    final notation = "$fromNotation to $toNotation";

    final legalMoves = _getLegalMoves(fromRow, fromCol);
    final isLegalChessMove = legalMoves.any((m) => m[0] == toRow && m[1] == toCol);

    if (!isLegalChessMove) {
      _addLog("PLAYER: Selected move to $toNotation is invalid for this piece.");
      setState(() {
        _selectedRow = null;
        _selectedCol = null;
      });
      return;
    }

    if (_puzzleStep == 0) {
      // White can play Qxd8+ (Queen from 3,0 to 0,3) OR Rxd8+ (Rook from 7,3 to 0,3)
      final isQueenMove = (fromRow == 3 && fromCol == 0 && toRow == 0 && toCol == 3);
      final isRookMove = (fromRow == 7 && fromCol == 3 && toRow == 0 && toCol == 3);

      if (isQueenMove || isRookMove) {
        _firstMovePiece = isQueenMove ? 'Q' : 'R';
        setState(() {
          final piece = _board[fromRow][fromCol];
          _board[toRow][toCol] = piece;
          _board[fromRow][fromCol] = '';
          _selectedRow = null;
          _selectedCol = null;
          _puzzleStep = 1;
          _progress = 0.6;
          _highlightFromRow = fromRow;
          _highlightFromCol = fromCol;
          _highlightToRow = toRow;
          _highlightToCol = toCol;
        });

        final moveNotation = isQueenMove ? "Qxd8+" : "Rxd8+";
        _addLog("PLAYER: $moveNotation (Correct deflection!)");
        _addLog("SYSTEM: Black plays Rxd8.");

        Future.delayed(const Duration(milliseconds: 800), () {
          if (!mounted) return;
          setState(() {
            // Black Rook from a8 (0,0) to d8 (0,3)
            _board[0][3] = 'r';
            _board[0][0] = '';
            _highlightFromRow = 0;
            _highlightFromCol = 0;
            _highlightToRow = 0;
            _highlightToCol = 3;
          });
          _addLog("SYSTEM: Black Rook captured your piece on d8.");
          _addLog("PUZZLE: White to move and deliver checkmate.");
        });
      } else {
        _addLog("PLAYER: Moved $notation (Incorrect. That is a legal move, but it does not lead to checkmate.)");
        setState(() {
          _selectedRow = null;
          _selectedCol = null;
        });
      }
    } else if (_puzzleStep == 1) {
      // If Move 1 was Queen, Move 2 must be Rook: (7,3) to (0,3)
      // If Move 1 was Rook, Move 2 must be Queen: (3,0) to (0,3)
      final isCorrectMove2 = (_firstMovePiece == 'Q' && fromRow == 7 && fromCol == 3 && toRow == 0 && toCol == 3) ||
                             (_firstMovePiece == 'R' && fromRow == 3 && fromCol == 0 && toRow == 0 && toCol == 3);

      if (isCorrectMove2) {
        setState(() {
          final piece = _board[fromRow][fromCol];
          _board[toRow][toCol] = piece;
          _board[fromRow][fromCol] = '';
          _selectedRow = null;
          _selectedCol = null;
          _puzzleStep = 2;
          _progress = 1.0;
          _highlightFromRow = fromRow;
          _highlightFromCol = fromCol;
          _highlightToRow = toRow;
          _highlightToCol = toCol;
        });
        final moveNotation = _firstMovePiece == 'Q' ? "Rxd8#" : "Qxd8#";
        _addLog("PLAYER: $moveNotation (Checkmate!)");
        _addLog("SYSTEM: Puzzle solved. Granting entry...");
        _onLoadingCompleted();
      } else {
        _addLog("PLAYER: Moved $notation (Incorrect. That is a legal move, but it does not lead to checkmate.)");
        setState(() {
          _selectedRow = null;
          _selectedCol = null;
        });
      }
    }
  }

  List<List<int>> _getLegalMoves(int row, int col) {
    final moves = <List<int>>[];
    final piece = _board[row][col];
    if (piece.isEmpty) return moves;

    final isWhite = piece == piece.toUpperCase();

    void addDir(int dRow, int dCol, {bool multiStep = true}) {
      int r = row + dRow;
      int c = col + dCol;
      while (r >= 0 && r < 8 && c >= 0 && c < 8) {
        final target = _board[r][c];
        if (target.isEmpty) {
          moves.add([r, c]);
        } else {
          final targetIsWhite = target == target.toUpperCase();
          if (isWhite != targetIsWhite) {
            // Capture enemy piece
            moves.add([r, c]);
          }
          break; // Blocked by piece
        }
        if (!multiStep) break;
        r += dRow;
        c += dCol;
      }
    }

    switch (piece.toUpperCase()) {
      case 'R':
        addDir(-1, 0);
        addDir(1, 0);
        addDir(0, -1);
        addDir(0, 1);
        break;
      case 'B':
        addDir(-1, -1);
        addDir(-1, 1);
        addDir(1, -1);
        addDir(1, 1);
        break;
      case 'Q':
        addDir(-1, 0);
        addDir(1, 0);
        addDir(0, -1);
        addDir(0, 1);
        addDir(-1, -1);
        addDir(-1, 1);
        addDir(1, -1);
        addDir(1, 1);
        break;
      case 'K':
        addDir(-1, 0, multiStep: false);
        addDir(1, 0, multiStep: false);
        addDir(0, -1, multiStep: false);
        addDir(0, 1, multiStep: false);
        addDir(-1, -1, multiStep: false);
        addDir(-1, 1, multiStep: false);
        addDir(1, -1, multiStep: false);
        addDir(1, 1, multiStep: false);
        break;
      case 'N':
        final offsets = [
          [-2, -1], [-2, 1], [-1, -2], [-1, 2],
          [1, -2], [1, 2], [2, -1], [2, 1]
        ];
        for (final o in offsets) {
          int r = row + o[0];
          int c = col + o[1];
          if (r >= 0 && r < 8 && c >= 0 && c < 8) {
            final target = _board[r][c];
            if (target.isEmpty || (target == target.toUpperCase()) != isWhite) {
              moves.add([r, c]);
            }
          }
        }
        break;
      case 'P':
        int dir = isWhite ? -1 : 1;
        int nextRow = row + dir;
        if (nextRow >= 0 && nextRow < 8 && _board[nextRow][col].isEmpty) {
          moves.add([nextRow, col]);
          int startRank = isWhite ? 6 : 1;
          int doubleRow = row + 2 * dir;
          if (row == startRank && _board[doubleRow][col].isEmpty) {
            moves.add([doubleRow, col]);
          }
        }
        for (int dCol in [-1, 1]) {
          int nextCol = col + dCol;
          if (nextRow >= 0 && nextRow < 8 && nextCol >= 0 && nextCol < 8) {
            final target = _board[nextRow][nextCol];
            if (target.isNotEmpty && (target == target.toUpperCase()) != isWhite) {
              moves.add([nextRow, nextCol]);
            }
          }
        }
        break;
    }
    return moves;
  }

  String _getCoordinatesNotation(int row, int col) {
    final file = String.fromCharCode('a'.codeUnitAt(0) + col);
    final rank = 8 - row;
    return "$file$rank";
  }

  void _showHint() {
    setState(() {
      _hintActive = true;
    });
    if (_puzzleStep == 0) {
      _addLog("SYSTEM: Hint - Deflect Black's Rook by capturing it on d8 with either your Queen (a5) or Rook (d1).");
    } else if (_puzzleStep == 1) {
      if (_firstMovePiece == 'Q') {
        _addLog("SYSTEM: Hint - Capture the Black Rook on d8 with your Rook (d1) to deliver back-rank checkmate.");
      } else {
        _addLog("SYSTEM: Hint - Capture the Black Rook on d8 with your Queen (a5) to deliver back-rank checkmate.");
      }
    }
  }

  void _addLog(String log) {
    if (mounted) {
      setState(() {
        _logs.add(log);
      });
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
                      foregroundColor: Colors.white.withValues(alpha: 0.5),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
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
                          color: Colors.white.withValues(alpha: 0.7),
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
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
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
                                  color: AppTheme.neon.withValues(alpha: 0.3),
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
                            .shimmer(delay: 500.ms, duration: 1500.ms, color: Colors.white.withValues(alpha: 0.5)),
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
        border: Border.all(color: AppTheme.neon.withValues(alpha: 0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.neon.withValues(alpha: 0.02),
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
                    Expanded(
                      child: Text(
                        "CONSOLE // LOG_DIAGNOSTICS",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.shareTechMono(
                          color: AppTheme.neon,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
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
                      Color logColor = Colors.white.withValues(alpha: 0.85);
                      if (log.startsWith("SYS_BOOT") || log.startsWith("SYSTEM")) {
                        logColor = AppTheme.neon;
                      } else if (log.startsWith("[CHESS]") || log.startsWith("PLAYER:")) {
                        logColor = AppTheme.purple.withAlpha(220);
                      } else if (log.startsWith("PUZZLE:")) {
                        logColor = Colors.amberAccent;
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
        border: Border.all(color: AppTheme.purple.withValues(alpha: 0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.purple.withValues(alpha: 0.02),
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
                Expanded(
                  child: Text(
                    "CHESS_MATRIX // PUZZLE",
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.shareTechMono(
                      color: AppTheme.purple,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "STOCKFISH v16.1",
                  style: GoogleFonts.shareTechMono(
                    color: Colors.white.withValues(alpha: 0.4),
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
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 2),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final cellSize = constraints.maxWidth / 8;
                        
                        final legalMoves = (_selectedRow != null && _selectedCol != null)
                            ? _getLegalMoves(_selectedRow!, _selectedCol!)
                            : <List<int>>[];

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

                            // Check selection and hint
                            final isSelected = row == _selectedRow && col == _selectedCol;
                            final isHintSquare = _hintActive &&
                                ((_puzzleStep == 0 && ((row == 3 && col == 0) || (row == 7 && col == 3) || (row == 0 && col == 3))) ||
                                 (_puzzleStep == 1 &&
                                  ((_firstMovePiece == 'Q' && ((row == 7 && col == 3) || (row == 0 && col == 3))) ||
                                   (_firstMovePiece == 'R' && ((row == 3 && col == 0) || (row == 0 && col == 3))))));

                            // Check if this square is highlighted as part of the last move
                            final isHighlighted = (row == _highlightFromRow && col == _highlightFromCol) ||
                                                   (row == _highlightToRow && col == _highlightToCol);

                            // Check if this square is a legal destination for the selected piece
                            final isLegalDestination = legalMoves.any((m) => m[0] == row && m[1] == col);

                            Color squareColor = isDarkSquare
                                ? Colors.white.withValues(alpha: 0.02)
                                : Colors.white.withValues(alpha: 0.06);

                            if (isSelected) {
                              squareColor = AppTheme.neon.withValues(alpha: 0.25);
                            } else if (isHintSquare) {
                              squareColor = Colors.amber.withValues(alpha: 0.2);
                            } else if (isHighlighted) {
                              // Highlight moves with gradient border or semi-transparent overlay
                              squareColor = (row == _highlightToRow && col == _highlightToCol)
                                  ? AppTheme.neon.withValues(alpha: 0.12)
                                  : AppTheme.purple.withValues(alpha: 0.12);
                            }

                            return GestureDetector(
                              key: ValueKey("square_${row}_${col}"),
                              onTap: () => _onSquareTap(row, col),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: squareColor,
                                  border: isSelected
                                      ? Border.all(color: AppTheme.neon, width: 2)
                                      : isHintSquare
                                          ? Border.all(color: Colors.amber, width: 2)
                                          : isHighlighted
                                              ? Border.all(
                                                  color: (row == _highlightToRow && col == _highlightToCol)
                                                      ? AppTheme.neon.withValues(alpha: 0.6)
                                                      : AppTheme.purple.withValues(alpha: 0.6),
                                                  width: 1.5,
                                                )
                                              : Border.all(color: Colors.white.withValues(alpha: 0.015), width: 0.5),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    if (piece.isNotEmpty)
                                      Text(
                                        _getPieceUnicode(piece),
                                        style: TextStyle(
                                          color: _getPieceColor(piece),
                                          fontSize: cellSize * 0.65,
                                        ),
                                      )
                                        .animate(target: (isHighlighted || isSelected || isHintSquare) ? 1.0 : 0.0)
                                        .scale(
                                          begin: const Offset(1.0, 1.0),
                                          end: const Offset(1.15, 1.15),
                                          duration: 250.ms,
                                          curve: Curves.easeOut,
                                        ),
                                    if (isLegalDestination)
                                      IgnorePointer(
                                        child: Container(
                                          width: piece.isEmpty ? 14 : cellSize * 0.8,
                                          height: piece.isEmpty ? 14 : cellSize * 0.8,
                                          decoration: BoxDecoration(
                                            color: piece.isEmpty
                                                ? AppTheme.neon.withValues(alpha: 0.35)
                                                : Colors.transparent,
                                            border: piece.isEmpty
                                                ? null
                                                : Border.all(
                                                    color: AppTheme.neon.withValues(alpha: 0.5),
                                                    width: 3,
                                                  ),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: _showHint,
                  icon: const Icon(Icons.lightbulb_outline, size: 14, color: AppTheme.purple),
                  label: Text(
                    "HINT",
                    style: GoogleFonts.shareTechMono(color: AppTheme.purple, fontSize: 11),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.purple.withValues(alpha: 0.3)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _launchPortfolio,
                  icon: const Icon(Icons.skip_next, size: 14, color: Colors.white60),
                  label: Text(
                    "SKIP PUZZLE",
                    style: GoogleFonts.shareTechMono(color: Colors.white70, fontSize: 11),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                ),
              ],
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
      ..color = Colors.white.withValues(alpha: 0.15)
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
      ..color = Colors.white.withValues(alpha: 0.2)
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
