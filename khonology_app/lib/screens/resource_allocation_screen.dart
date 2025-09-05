import 'package:flutter/material.dart';

class ResourceAllocationScreen extends StatefulWidget {
  const ResourceAllocationScreen({super.key});

  @override
  State<ResourceAllocationScreen> createState() => _ResourceAllocationScreenState();
}

class _ResourceAllocationScreenState extends State<ResourceAllocationScreen> {
  String _selectedProject = 'All Projects';
  String _selectedResource = 'All Resources';
  String _selectedMonth = 'THIS MONTH';
  bool _showPerProject = true;

  final List<String> _projects = ['All Projects', 'KhonoBuzz', 'RIM', 'DCM', 'PayDor'];
  final List<String> _resources = ['All Resources', 'John Doe', 'Jane Smith', 'Mike Johnson'];
  final List<String> _months = ['THIS MONTH', 'NEXT MONTH', 'OCTOBER 2023', 'NOVEMBER 2023'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resource Allocation',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          
          // Filters
          Card(
            color: const Color(0xFF2A2A2A),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdown('Project', _selectedProject, _projects, (value) {
                          setState(() {
                            _selectedProject = value!;
                          });
                        }),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDropdown('Resource', _selectedResource, _resources, (value) {
                          setState(() {
                            _selectedResource = value!;
                          });
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown('Applicable Month Selection', _selectedMonth, _months, (value) {
                    setState(() {
                      _selectedMonth = value!;
                    });
                  }),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Generate report
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('GET REPORT'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Toggle buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showPerProject = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _showPerProject ? Colors.red : const Color(0xFF2A2A2A),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('ALLOCATED CAPACITY PER PROJECT'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showPerProject = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !_showPerProject ? Colors.red : const Color(0xFF2A2A2A),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('ALLOCATED CAPACITY PER RESOURCE'),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Data table
          Expanded(
            child: Card(
              color: const Color(0xFF2A2A2A),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _showPerProject ? _buildProjectTable() : _buildResourceTable(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Color(0xFF1A1A1A),
          ),
          dropdownColor: const Color(0xFF1A1A1A),
          style: const TextStyle(color: Colors.white),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildProjectTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(const Color(0xFF1A1A1A)),
        dataRowColor: WidgetStateProperty.all(const Color(0xFF2A2A2A)),
        columns: const [
          DataColumn(label: Text('Project Name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Client Organisation', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Project Tags', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Resource Name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Resource Role', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Task Tags', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Allocated Capacity', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        ],
        rows: [
          _buildDataRow('KhonoBuzz', 'Khonology Ltd', 'Mobile App', 'John Doe', 'Developer', 'Frontend', 0.8),
          _buildDataRow('RIM', 'RIM Corp', 'Web Platform', 'Jane Smith', 'Designer', 'UI/UX', 0.6),
          _buildDataRow('DCM', 'DCM Inc', 'Data Management', 'Mike Johnson', 'Analyst', 'Backend', 0.9),
          _buildDataRow('PayDor', 'PayDor Ltd', 'Payment System', 'Sarah Wilson', 'Manager', 'Project Management', 0.7),
        ],
      ),
    );
  }

  Widget _buildResourceTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(const Color(0xFF1A1A1A)),
        dataRowColor: WidgetStateProperty.all(const Color(0xFF2A2A2A)),
        columns: const [
          DataColumn(label: Text('Resource Name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Resource Role', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Task Tags', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Total Allocated Capacity', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        ],
        rows: [
          _buildResourceDataRow('John Doe', 'Developer', 'Frontend, Backend', 0.85),
          _buildResourceDataRow('Jane Smith', 'Designer', 'UI/UX, Graphics', 0.75),
          _buildResourceDataRow('Mike Johnson', 'Analyst', 'Data Analysis, Backend', 0.90),
          _buildResourceDataRow('Sarah Wilson', 'Manager', 'Project Management', 0.65),
        ],
      ),
    );
  }

  DataRow _buildDataRow(String projectName, String clientOrg, String projectTags, 
                       String resourceName, String resourceRole, String taskTags, double capacity) {
    return DataRow(
      cells: [
        DataCell(Text(projectName, style: const TextStyle(color: Colors.white))),
        DataCell(Text(clientOrg, style: const TextStyle(color: Colors.white))),
        DataCell(Text(projectTags, style: const TextStyle(color: Colors.white))),
        DataCell(Text(resourceName, style: const TextStyle(color: Colors.white))),
        DataCell(Text(resourceRole, style: const TextStyle(color: Colors.white))),
        DataCell(Text(taskTags, style: const TextStyle(color: Colors.white))),
        DataCell(_buildCapacityBar(capacity)),
      ],
    );
  }

  DataRow _buildResourceDataRow(String resourceName, String resourceRole, String taskTags, double capacity) {
    return DataRow(
      cells: [
        DataCell(Text(resourceName, style: const TextStyle(color: Colors.white))),
        DataCell(Text(resourceRole, style: const TextStyle(color: Colors.white))),
        DataCell(Text(taskTags, style: const TextStyle(color: Colors.white))),
        DataCell(_buildCapacityBar(capacity)),
      ],
    );
  }

  Widget _buildCapacityBar(double capacity) {
    return Container(
      width: 100,
      height: 20,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Container(
            width: 100 * capacity,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Center(
            child: Text(
              '${(capacity * 100).toInt()}%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

