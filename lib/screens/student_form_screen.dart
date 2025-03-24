import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/database_helper.dart';

class StudentFormScreen extends StatefulWidget {
  final Student? student;

  const StudentFormScreen({super.key, this.student});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nimController = TextEditingController();
  final _namaController = TextEditingController();
  final _kelasController = TextEditingController();
  final _jurusanController = TextEditingController();
  final _programStudiController = TextEditingController();
  bool _isLoading = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.student != null;
    if (_isEditing) {
      _nimController.text = widget.student!.nim;
      _namaController.text = widget.student!.nama;
      _kelasController.text = widget.student!.kelas;
      _jurusanController.text = widget.student!.jurusan;
      _programStudiController.text = widget.student!.programStudi;
    }
  }

  @override
  void dispose() {
    _nimController.dispose();
    _namaController.dispose();
    _kelasController.dispose();
    _jurusanController.dispose();
    _programStudiController.dispose();
    super.dispose();
  }

  Future<void> _saveStudent() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final student = Student(
          id: _isEditing ? widget.student!.id : null,
          nim: _nimController.text.trim(),
          nama: _namaController.text.trim(),
          kelas: _kelasController.text.trim(),
          jurusan: _jurusanController.text.trim(),
          programStudi: _programStudiController.text.trim(),
        );

        if (_isEditing) {
          await DatabaseHelper.instance.updateStudent(student);
        } else {
          // Check if NIM already exists
          final existingStudent = await DatabaseHelper.instance
              .getStudentByNim(_nimController.text.trim());

          if (existingStudent != null) {
            setState(() {
              _isLoading = false;
            });
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('NIM already exists'),
                  backgroundColor: Colors.red,
                ),
              );
            }
            return;
          }

          await DatabaseHelper.instance.createStudent(student);
        }

        setState(() {
          _isLoading = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_isEditing
                  ? 'Student updated successfully'
                  : 'Student added successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Student' : 'Add Student'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nimController,
                decoration: const InputDecoration(
                  labelText: 'NIM',
                  border: OutlineInputBorder(),
                  helperText: 'Student ID Number',
                ),
                enabled: !_isEditing, // Disable NIM editing
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter NIM';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                  helperText: 'Student Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _kelasController,
                decoration: const InputDecoration(
                  labelText: 'Kelas',
                  border: OutlineInputBorder(),
                  helperText: 'Class',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter class';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jurusanController,
                decoration: const InputDecoration(
                  labelText: 'Jurusan',
                  border: OutlineInputBorder(),
                  helperText: 'Department',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter department';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _programStudiController,
                decoration: const InputDecoration(
                  labelText: 'Program Studi',
                  border: OutlineInputBorder(),
                  helperText: 'Study Program',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter study program';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveStudent,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Text(_isEditing ? 'Update' : 'Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
