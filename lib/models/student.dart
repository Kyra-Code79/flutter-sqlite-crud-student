class Student {
  final int? id;
  final String nim;
  final String nama;
  final String kelas;
  final String jurusan;
  final String programStudi;

  Student({
    this.id,
    required this.nim,
    required this.nama,
    required this.kelas,
    required this.jurusan,
    required this.programStudi,
  });

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      nim: map['nim'],
      nama: map['nama'],
      kelas: map['kelas'],
      jurusan: map['jurusan'],
      programStudi: map['program_studi'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nim': nim,
      'nama': nama,
      'kelas': kelas,
      'jurusan': jurusan,
      'program_studi': programStudi,
    };
  }
}

