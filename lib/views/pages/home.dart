part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Province> provinceData = []; ///
  bool isLoading = false;
  String selectedCourier = 'jne';
  var kurir = ['jne', 'pos', 'tiki'];

  final ctrlBerat = TextEditingController();

  dynamic provId;
  dynamic listProvince;
  dynamic selectedProvOrigin;
  dynamic selectedProvDestination;

  Future<List<Province>> getProvinces() async{
    dynamic provinceData;
    await MasterDataService.getProvince().then((value) {
      setState(() {
        provinceData = value; 
        isLoading = false;
      });
    });
    return provinceData;
  }

  dynamic cityDataOrigin;
  dynamic cityIdOrigin;
  dynamic selectedCityOrigin;
  dynamic cityIdDestination;
  dynamic cityDataDestination;
  dynamic selectedCityDestination;

  Future<List<City>> getCities(var provId) async{
    dynamic city;
    await MasterDataService.getCity(provId).then((value) {
      setState(() {
        city = value;
      });
    });

    return city;
  }

  bool isProvinceOriginSelected = false;
  bool isCityOriginSelected = false;

  bool isProvinceDestinationSelected = false;
  bool isCityDestinationSelected = false;

  List<Costs> listCosts = [];
  Future<dynamic> getCostsData() async {
    await RajaOngkirServices.getMyOngkir(cityIdOrigin, cityIdDestination,
            int.parse(ctrlBerat.text), selectedCourier)
        .then((value) {
      setState(() {
        listCosts = value;
        isLoading = false;
      });
      print(listCosts.toString());
    });
  }
  
  @override
   void initState() {
      super.initState();
      listProvince = getProvinces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Hitung Ongkir", style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
       child: Container(
          height: 1400,
          child: Stack(
            children: [
              Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    children: [
                      // Form isi data
                      Flexible(
                        flex: 3,
                        child: Column(
                          children: [
                      
                            const Padding(
                                // Pilih courier
                                padding: EdgeInsets.all(16.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Courier",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.purple),
                                  ),
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  DropdownButton(
                                      value: selectedCourier,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      items: kurir.map((String items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedCourier = newValue!;
                                        });
                                      }),
                                  SizedBox(
                                      width: 200,
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: ctrlBerat,
                                        decoration: const InputDecoration(
                                          labelText: 'Berat (gr)',
                                        ),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          return value == null || value == 0
                                              ? 'Berat harus diisi dan tidak boleh 0!'
                                              : null;
                                        },
                                      ))
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Padding(
                                // Choose Origin
                                padding: EdgeInsets.all(16.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Origin",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.purple),
                                  ),
                                )),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 160,
                                      child: FutureBuilder<List<Province>>(
                                          future: listProvince,
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return DropdownButton(
                                                  isExpanded: true,
                                                  value: selectedProvOrigin,
                                                  icon: const Icon(
                                                      Icons.arrow_drop_down),
                                                  iconSize: 30,
                                                  elevation: 16,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  hint: selectedProvOrigin ==
                                                          null
                                                      ? Text('Pilih provinsi asal')
                                                      : Text(selectedProvOrigin
                                                          .province),
                                                  items: snapshot.data!.map<
                                                          DropdownMenuItem<
                                                              Province>>(
                                                      (Province value) {
                                                    return DropdownMenuItem(
                                                        value: value,
                                                        child: Text(value
                                                            .province
                                                            .toString()));
                                                  }).toList(),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      selectedProvOrigin =
                                                          newValue;
                                                      provId =
                                                          selectedProvOrigin
                                                              .provinceId;
                                                      isProvinceOriginSelected =
                                                          true;
                                                    });
                                                    selectedCityOrigin = null;
                                                    cityDataOrigin =
                                                        getCities(provId);
                                                  });
                                            } else if (snapshot.hasError) {
                                              return const Text(
                                                  "Tidak ada data.");
                                            }

                                            return UiLoading.loadingSmall();
                                          }),
                                    ),
                                    Container(
                                      width: 160,
                                      child: FutureBuilder<List<City>>(
                                          future: cityDataOrigin,
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              return DropdownButton(
                                                  isExpanded: true,
                                                  value: selectedCityOrigin,
                                                  icon: const Icon(
                                                      Icons.arrow_drop_down),
                                                  iconSize: 30,
                                                  elevation: 16,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  hint: selectedCityOrigin ==
                                                          null
                                                      ? Text('Pilih kota asal')
                                                      : Text(selectedCityOrigin
                                                          .cityName),
                                                  items: snapshot.data!.map<
                                                      DropdownMenuItem<
                                                          City>>((City value) {
                                                    return DropdownMenuItem(
                                                        value: value,
                                                        child: Text(value
                                                            .cityName
                                                            .toString()));
                                                  }).toList(),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      selectedCityOrigin =
                                                          newValue;
                                                      isCityOriginSelected =
                                                          true;
                                                      cityIdOrigin =
                                                          selectedCityOrigin
                                                              .cityId;
                                                    });
                                                  });
                                            } else if (snapshot.hasError) {
                                              return const Text(
                                                  "Tidak ada data.");
                                            }

                                            if (isProvinceOriginSelected ==
                                                false) {
                                              return Text(
                                                  "Pilih provinsi asal terlebih dahulu");
                                            } else {
                                              return UiLoading.loadingSmall();
                                            }
                                          }),
                                    ),
                                  ],
                                )),
                            const SizedBox(
                              height: 24,
                            ),
                            const Padding(
                                // Choose Destination
                                padding: EdgeInsets.all(16.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Destination",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.purple),
                                  ),
                                )),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 160,
                                      child: FutureBuilder<List<Province>>(
                                          future: listProvince,
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return DropdownButton(
                                                  isExpanded: true,
                                                  value:
                                                      selectedProvDestination,
                                                  icon: const Icon(
                                                      Icons.arrow_drop_down),
                                                  iconSize: 30,
                                                  elevation: 16,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  hint: selectedProvDestination ==
                                                          null
                                                      ? Text('Pilih provinsi tujuan')
                                                      : Text(
                                                          selectedProvDestination
                                                              .province),
                                                  items: snapshot.data!.map<
                                                          DropdownMenuItem<
                                                              Province>>(
                                                      (Province value) {
                                                    return DropdownMenuItem(
                                                        value: value,
                                                        child: Text(value
                                                            .province
                                                            .toString()));
                                                  }).toList(),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      selectedProvDestination =
                                                          newValue;
                                                      provId =
                                                          selectedProvDestination
                                                              .provinceId;
                                                      isProvinceDestinationSelected =
                                                          true;
                                                    });
                                                    selectedCityDestination =
                                                        null;
                                                    cityDataDestination =
                                                        getCities(provId);
                                                  });
                                            } else if (snapshot.hasError) {
                                              return const Text(
                                                  "Tidak ada data.");
                                            }
                                            return UiLoading.loadingSmall();
                                          }),
                                    ),
                                    Container(
                                      width: 160,
                                      child: FutureBuilder<List<City>>(
                                          future: cityDataDestination,
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              return DropdownButton(
                                                  isExpanded: true,
                                                  value:
                                                      selectedCityDestination,
                                                  icon: const Icon(
                                                      Icons.arrow_drop_down),
                                                  iconSize: 30,
                                                  elevation: 16,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  hint: selectedCityDestination ==
                                                          null
                                                      ? Text('Pilih kota tujuan')
                                                      : Text(
                                                          selectedCityDestination
                                                              .cityName),
                                                  items: snapshot.data!.map<
                                                      DropdownMenuItem<
                                                          City>>((City value) {
                                                    return DropdownMenuItem(
                                                        value: value,
                                                        child: Text(value
                                                            .cityName
                                                            .toString()));
                                                  }).toList(),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      selectedCityDestination =
                                                          newValue;
                                                      isCityDestinationSelected =
                                                          true;
                                                      cityIdDestination =
                                                          selectedCityDestination
                                                              .cityId;
                                                    });
                                                  });
                                            } else if (snapshot.hasError) {
                                              return const Text(
                                                  "Tidak ada data.");
                                            }

                                            if (isProvinceDestinationSelected ==
                                                false) {
                                              return Text(
                                                  "Pilih provinsi tujuan terlebih dahulu");
                                            } else {
                                              return UiLoading.loadingSmall();
                                            }
                                          }),
                                    ),
                                  ],
                                )),
                            SizedBox(height: 50),
                            ElevatedButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ))),
                                onPressed: () async {
                                  if (isProvinceDestinationSelected == true &&
                                      isProvinceOriginSelected == true &&
                                      isCityDestinationSelected == true &&
                                      isCityOriginSelected == true &&
                                      selectedCourier.isNotEmpty &&
                                      ctrlBerat.text.isNotEmpty) {
                                        
                                    setState(() {
                                      isLoading = true;
                                    });
                                    await getCostsData();
                                    setState(() {
                                      isLoading = false;
                                    });
                                  } else {
                                    UiToast.toastErr("Semua field harus diisi");
                                  }
                                },
                                child: Text("Hitung Estimasi Harga"))
                          ],
                        ),
                      ),
                    
                      //Card hasil ongkir
                      Flexible(
                        flex: 4,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: listCosts.isEmpty
                              ? const Align(
                                  alignment: Alignment.topCenter,
                                  child: Text("Silakan isi semua field terlebih dahulu"))
                              : ListView.builder(
                                  itemCount: listCosts.length,
                                  itemBuilder: (context, index) {
                                    return LazyLoadingList(
                                        initialSizeOfItems: 10,
                                        loadMore: () {},
                                        child: CardOngkir(listCosts[index]),
                                        index: index,
                                        hasMore: true);
                                  },
                                ),
                        ),
                      ),
                    ],
                  )),
              isLoading == true ? UiLoading.loadingBlock() : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
