import 'package:flutter/material.dart';
import '../models/progress_record.dart';

enum NavigationItem {
  home,
  settings,
}

class AppScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final ProgressRecord progress;
  final NavigationItem selectedItem;
  final Function(NavigationItem) onNavigate;
  
  const AppScaffold({
    super.key,
    required this.body,
    required this.title,
    required this.progress,
    required this.selectedItem,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    // Determine max available levels (for the sidebar)
    const int maxLevel = 10; // Maximum available level
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      drawer: MediaQuery.of(context).size.width < 600 ? _buildDrawer(context, maxLevel) : null,
      body: Row(
        children: [
          // Show sidebar only on larger screens
          if (MediaQuery.of(context).size.width >= 600)
            SizedBox(
              width: 80,
              child: _buildSidebarContent(maxLevel),
            ),
          
          // Main content
          Expanded(child: body),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedItem.index,
        onTap: (index) => onNavigate(NavigationItem.values[index]),
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, int maxLevel) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
            ),
            child: const Center(
              child: Text(
                'Number Sense',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildSidebarContent(maxLevel),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarContent(int maxLevel) {
    return Container(
      color: Colors.grey.shade100,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 20),
        itemCount: maxLevel,
        itemBuilder: (context, index) {
          final level = index + 1;
          // Determine level status
          bool isCurrentLevel = level == progress.level;
          bool isCompleted = level < progress.level;
          bool isLocked = level > progress.level;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: LevelIndicator(
              level: level,
              isCurrentLevel: isCurrentLevel,
              isCompleted: isCompleted,
              isLocked: isLocked,
            ),
          );
        },
      ),
    );
  }
}

class LevelIndicator extends StatelessWidget {
  final int level;
  final bool isCurrentLevel;
  final bool isCompleted;
  final bool isLocked;

  const LevelIndicator({
    super.key,
    required this.level,
    required this.isCurrentLevel,
    required this.isCompleted,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    IconData? icon;

    if (isCurrentLevel) {
      bgColor = Colors.blue.shade700;
      textColor = Colors.white;
      icon = Icons.play_arrow;
    } else if (isCompleted) {
      bgColor = Colors.green.shade600;
      textColor = Colors.white;
      icon = Icons.check;
    } else {
      bgColor = Colors.grey.shade300;
      textColor = isLocked ? Colors.grey.shade600 : Colors.black87;
      icon = isLocked ? Icons.lock : null;
    }

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: isCurrentLevel ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ] : null,
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$level',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 4),
              Icon(icon, color: textColor, size: 16),
            ]
          ],
        ),
      ),
    );
  }
}