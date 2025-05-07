import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mahasiswa_stt/helper/database_helper.dart';
import 'package:mahasiswa_stt/page/dashboard.dart';

class Mahasiswa extends StatefulWidget {
  const Mahasiswa({super.key});

  @override
  State<Mahasiswa> createState() => _MahasiswaState();
}

class _MahasiswaState extends State<Mahasiswa> {
  TextEditingController nameController = TextEditingController();
  TextEditingController nimController = TextEditingController();
  TextEditingController tugasController = TextEditingController();
  TextEditingController utsController = TextEditingController();
  TextEditingController uasController = TextEditingController();

  var _nilaiAkhir = 0.0;
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      var data = Get.arguments;
      nameController.text = data['nama'];
      nimController.text = data['nim'].toString();
      tugasController.text = data['tugas'].toString();
      utsController.text = data['uts'].toString();
      uasController.text = data['uas'].toString();
      _nilaiAkhir = data['nilai_akhir'];
      isEdit = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Detail Mahasiswa" : "Input Mahasiswa"),
        actions: [
          Visibility(
            visible: isEdit,
            child: IconButton(
              onPressed: () {
                Get.defaultDialog(
                  title: "Hapus Semua Data",
                  middleText: "Apakah Anda yakin ingin menghapus semua data?",
                  onConfirm: () {
                    DataBaseHelper.deleteWhere(
                      'mahasiswa',
                      'nim=?',
                      int.parse(nimController.text),
                    );
                    Get.offAll(() => Dashboard());
                  },
                  onCancel: () {
                    Get.closeAllSnackbars();
                  },
                );
              },
              icon: Icon(Icons.delete),
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Nama",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: nimController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              readOnly: isEdit,
              decoration: InputDecoration(
                labelText: "NIM",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: tugasController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Nilai Tugas",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: utsController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Nilai UTS",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: uasController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Nilai UAS",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty &&
                      nimController.text.isNotEmpty &&
                      tugasController.text.isNotEmpty &&
                      utsController.text.isNotEmpty &&
                      uasController.text.isNotEmpty) {
                    double tugas = double.parse(tugasController.text);
                    double uts = double.parse(utsController.text);
                    double uas = double.parse(uasController.text);

                    setState(() {
                      _nilaiAkhir = (tugas * 0.3) + (uts * 0.3) + (uas * 0.4);
                    });
                  } else {
                    Get.snackbar(
                      "Error",
                      "Semua field harus diisi",
                      backgroundColor: Colors.red[900],
                      colorText: Colors.white,
                    );
                  }
                },
                child: Text("Hitung Nilai"),
              ),
            ),
            SizedBox(height: 10),
            Text("Nilai Akhir: $_nilaiAkhir", style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          if (nameController.text.isNotEmpty &&
              nimController.text.isNotEmpty &&
              tugasController.text.isNotEmpty &&
              utsController.text.isNotEmpty &&
              uasController.text.isNotEmpty &&
              _nilaiAkhir != 0) {
            Get.defaultDialog(
              title: "Simpan Data",
              middleText: "Apakah Anda yakin ingin menyimpan data?",
              onConfirm: () {
                if (isEdit) {
                  DataBaseHelper.deleteWhere(
                    'mahasiswa',
                    'nim=?',
                    int.parse(nimController.text),
                  );
                  DataBaseHelper.insert('mahasiswa', {
                    'nim': int.parse(nimController.text),
                    'nama': nameController.text,
                    'tugas': double.parse(tugasController.text),
                    'uts': double.parse(utsController.text),
                    'uas': double.parse(uasController.text),
                    'nilai_akhir': _nilaiAkhir,
                  });
                  Get.offAll(() => Dashboard());
                } else {
                  DataBaseHelper.getWhere(
                    "mahasiswa",
                    "nim=${nimController.text}",
                  ).then((value) {
                    if (value.isNotEmpty) {
                      Get.snackbar(
                        "Error",
                        "NIM sudah terdaftar",
                        backgroundColor: Colors.red[900],
                        colorText: Colors.white,
                      );
                    } else {
                      DataBaseHelper.insert('mahasiswa', {
                        'nim': int.parse(nimController.text),
                        'nama': nameController.text,
                        'tugas': double.parse(tugasController.text),
                        'uts': double.parse(utsController.text),
                        'uas': double.parse(uasController.text),
                        'nilai_akhir': _nilaiAkhir,
                      });
                      Get.offAll(() => Dashboard());
                    }
                  });
                }
              },
              onCancel: () {
                Get.closeAllSnackbars();
              },
            );
          } else {
            Get.snackbar(
              "Error",
              "Semua field harus diisi, dan pastikan nilai akhir sudah dihitung",
              backgroundColor: Colors.red[900],
              colorText: Colors.white,
            );
          }
        },
      ),
    );
  }
}
