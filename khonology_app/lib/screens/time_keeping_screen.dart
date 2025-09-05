import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class TimeKeepingScreen extends StatefulWidget {
  const TimeKeepingScreen({super.key});

  @override
  State<TimeKeepingScreen> createState() => _TimeKeepingScreenState();
}

class _TimeKeepingScreenState extends State<TimeKeepingScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedFile;
  String _selectedPeriod = 'APPROVED';
  final List<String> _selectedProjects = [];
  bool _showUploadResult = false;
  bool _uploadSuccess = false;

  final List<String> _periods = ['APPROVED', 'SUBMITTED', 'SAVED', 'ARCHIVED'];
  final List<String> _projects = ['KhonoBuzz', 'RIM', 'DCM', 'PayDor'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showUploadResult) {
      return _buildUploadResult();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Time Keeping',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          
          // Tab bar
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.red,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: const [
                Tab(text: 'RIM'),
                Tab(text: 'DCM'),
                Tab(text: 'PsyDor'),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTimeKeepingContent(),
                _buildTimeKeepingContent(),
                _buildTimeKeepingContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeKeepingContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // File upload area
          Card(
            color: const Color(0xFF2A2A2A),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickFile,
                    child: Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white70, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.cloud_upload,
                            size: 48,
                            color: Colors.white70,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _selectedFile ?? 'Drop TIMESHEET Excel file here!',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Period selection
          Card(
            color: const Color(0xFF2A2A2A),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Period',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _periods.map((period) {
                      final isSelected = _selectedPeriod == period;
                      return ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedPeriod = period;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected ? Colors.red : const Color(0xFF1A1A1A),
                          foregroundColor: Colors.white,
                        ),
                        child: Text(period),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Search by date functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A1A1A),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('SEARCH BY DATE'),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Project selection
          Card(
            color: const Color(0xFF2A2A2A),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Project',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._projects.map((project) {
                    final isSelected = _selectedProjects.contains(project);
                    return CheckboxListTile(
                      title: Text(
                        project,
                        style: const TextStyle(color: Colors.white),
                      ),
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedProjects.add(project);
                          } else {
                            _selectedProjects.remove(project);
                          }
                        });
                      },
                      activeColor: Colors.red,
                      checkColor: Colors.white,
                    );
                  }),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Action button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedFile != null ? _processTimesheet : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'GET DATA & IMPORT TIMESHEET',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadResult() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _uploadSuccess ? Icons.check_circle : Icons.error,
            size: 80,
            color: _uploadSuccess ? Colors.green : Colors.red,
          ),
          const SizedBox(height: 24),
          Text(
            _uploadSuccess
                ? 'Your PROJECT Data Excel document has been SUCCESSFULLY UPLOADED.'
                : 'Your PROJECT Data Excel document encountered an ERROR UPLOADING.',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _showUploadResult = false;
                  _selectedFile = null;
                  _selectedProjects.clear();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _uploadSuccess ? Colors.green : Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'BACK',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = result.files.single.name;
      });
    }
  }

  void _processTimesheet() {
    // Simulate processing
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showUploadResult = true;
        _uploadSuccess = DateTime.now().millisecond % 2 == 0; // Random success/failure
      });
    });
  }
}

