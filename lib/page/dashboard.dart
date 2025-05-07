import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mahasiswa_stt/helper/api.dart';
import 'package:mahasiswa_stt/helper/database_helper.dart';
import 'package:mahasiswa_stt/page/mahasiswa.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Widget> mahasiswaList = [];
  var quotes =
          "Jangan pernah menyerah pada impianmu, karena impian adalah kunci kesuksesan.",
      author = "Unknown";

  @override
  void initState() {
    super.initState();
    getListMahasiswa();
    getQuotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mahasiswa STT"),
        actions: [
          IconButton(
            onPressed: () {
              getListMahasiswa();
              getQuotes();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Quotes :\n\"$quotes\" \n- $author",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: mahasiswaList.length,
                itemBuilder: (context, index) {
                  return mahasiswaList[index];
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const Mahasiswa(), transition: Transition.rightToLeft);
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }

  void getListMahasiswa() {
    mahasiswaList.clear();
    DataBaseHelper.getAll('mahasiswa').then((value) {
      for (var element in value) {
        setState(() {
          mahasiswaList.add(
            InkWell(
              onTap: () {
                Get.to(() => Mahasiswa(), arguments: element);
              },
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {
                      0: FlexColumnWidth(3),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(6),
                    },
                    border: TableBorder(
                      horizontalInside: BorderSide(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    children: [
                      TableRow(
                        children: [
                          const Text("NIM"),
                          const Text(":"),
                          Text(element['nim'].toString()),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Text("Nama"),
                          const Text(":"),
                          Text(element['nama'].toString().toUpperCase()),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Text("Nilai Akhir"),
                          const Text(":"),
                          Text(element['nilai_akhir'].toString()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      }
    });
    setState(() {});
  }

  void getQuotes() {
    Api.getData(context).then((value) {
      print(value);
      if (value != null) {
        setState(() {
          quotes = value.quote!;
          author = value.author!;
        });
      } else {
        setState(() {
          quotes = "Gagal Mengambil Data";
          author = "Unknown";
        });
      }
    });
  }
}
