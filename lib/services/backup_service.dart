import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mobile_parts_app/db/database_helper.dart';

class BackupService {
  static Future<void> backupDatabase(BuildContext context) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'mobile_parts.db');
      final file = File(path);

      if (await file.exists()) {
        await Share.shareXFiles([XFile(path)], text: 'Mobile Parts Database Backup');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Database file not found')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e')),
      );
    }
  }

  static Future<void> restoreDatabase(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.single.path != null) {
        final newDbFile = File(result.files.single.path!);
        
        // rudimentary validation
        if (!newDbFile.path.endsWith('.db') && !newDbFile.path.endsWith('.sqlite')) {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid file type. Please select a .db file')),
          );
          return;
        }

        final dbPath = await getDatabasesPath();
        final path = join(dbPath, 'mobile_parts.db');

        // Close DB first
        await DatabaseHelper.instance.close();

        // Copy overwrite
        await newDbFile.copy(path);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Restore successful. Restarting app recommended.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Restore failed: $e')),
      );
    }
  }
}
