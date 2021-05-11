import 'dart:io' as Io;
import 'dart:io';
import 'dart:typed_data';
import 'package:hello_world/models/animaltypes.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'dart:convert' as convert;
import '../jwt.dart';
import 'addpet.dart';
import 'leftside_menu.dart';

class PetsPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class Constants{
  Constants._();
  static const double padding =20;
  static const double avatarRadius =45;
}

class _IndexPageState extends State<PetsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _animaltypeController = TextEditingController();
  final TextEditingController _raceController = TextEditingController();
  List pets = [];
  List<Map<String, dynamic>> petsType = animalTypes;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    this.getPets();
  }

  getPets() async {
    var jwt = await storage.read(key: "jwt");
    var results = parseJwtPayLoad(jwt);
    int id = results["UserID"];
    var response = await http.get(
      Uri.parse('http://52.47.179.213:8081/api/v1/userAnimals/$id'),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );

    if (response.statusCode == 200) {
      var items = json.decode(response.body)['data'];
      setState(() {
        pets = items;
        isLoading = false;
      });
     
    } else {
      pets = [];
      isLoading = false;
    }
  }

 

  deletePet(int id) async {
    var jwt = await storage.read(key: "jwt");
    var response = await http.delete(
      Uri.parse('http://52.47.179.213:8081/api/v1/animal/$id'),
      headers: {HttpHeaders.authorizationHeader: jwt},
    );
    print(response.body);
    if (response.statusCode == 200) {
      print("Pet $id was deleted");
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => NavDrawer()),
                (Route<dynamic> route) => false);
          },
        ),
        title: Text("My Pets List"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'New Pet',
            onPressed: () {
              Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddPetPage()),
                  );
            },
          ),
        ],
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    if (pets.contains(null) || pets.length < 0 || isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
        itemCount: pets.length,
        itemBuilder: (context, index) {
          return getCard(pets[index]);
        });
  }

  Widget getCard(item) {
    var id = item['ID'];
    var name = item['name'];
    var animaltype = item['animaltype'];
    String profileUrl = item['profilePicture'];
    
    Uint8List bytes = base64.decode(profileUrl);

    
      
    return Card(
        elevation: 1.5,
        child: new InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => buildShowPet(item),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              title: Row(
                children: <Widget>[
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60 / 2),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: MemoryImage(bytes),
                           
                            )
                            ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                          width: MediaQuery.of(context).size.width - 190,
                          child: Text(
                            name,
                            style: TextStyle(fontSize: 17),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        animaltype.toString(),
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                     
                     showDialog(
                        context: context,
                        builder: (BuildContext context) => _showDialog(id),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }



  Widget buildShowPet(item) {
      return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context,item),
    );
  }


 contentBox(context,item){
   var name=item['name'];
   var animaltype=item['animaltype'];
   var race=item['race'];
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: Constants.padding,top: Constants.avatarRadius
              + Constants.padding, right: Constants.padding,bottom: Constants.padding
          ),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(Constants.padding),
            boxShadow: [
              BoxShadow(color: Colors.black,offset: Offset(0,10),
              blurRadius: 10
              ),
            ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(name,style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
              SizedBox(height: 15,),
              Text(animaltype ,style: TextStyle(fontSize: 14),textAlign: TextAlign.center,),
              SizedBox(height: 22,),
              Text(race ,style: TextStyle(fontSize: 14),textAlign: TextAlign.center,),
              SizedBox(height: 22,),
              Align(
                alignment: Alignment.bottomRight,
                child:TextButton(                                    
                  style: TextButton.styleFrom(primary: Colors.green[300]),
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    child: Text("Close",style: TextStyle(fontSize: 18),)),
              ),
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
            right: Constants.padding,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: Constants.avatarRadius,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                  child: Image.network("https://cdn.discordapp.com/attachments/537753005953384448/838351477395292210/f_00001b.png")
              ),
            ),
        ),
      ],
    );
  }

  Widget _buildAddpet() {
    return new AlertDialog(
      content: Stack(
        children: <Widget>[
          Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Pet Name"),
                    controller: _nameController,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SelectFormField(
                    decoration: InputDecoration(labelText: "Animal Type"),
                    type: SelectFormFieldType.dropdown,
                     items: petsType,
                    controller: _animaltypeController,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Race"),
                    controller: _raceController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    child: Text("Submit"),
                    style: TextButton.styleFrom(primary: Colors.green[300]),
                    onPressed: () {
                      var name = _nameController.text;
                      var animaltype = _animaltypeController.text;
                      var race = _raceController.text;
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) => PetsPage()),
                          (Route<dynamic> route) => false);
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

 Widget _showDialog(int id) {
    return AlertDialog(
      title: new Text("Delete pet",textAlign: TextAlign.center,),
      content: new Text("Are you sure that you want to delete this pet?",textAlign: TextAlign.center),
      actions: <Widget>[
        new TextButton(
          child: new Text("No"),
          onPressed: () {
             Navigator.of(context).pop();
          },
        ),
        Padding(
          padding:const EdgeInsets.only(left:178),
          child: TextButton(
             style: TextButton.styleFrom(
                      primary: Colors.red,
                    ),
            child: new Text("Yes"),
            onPressed: () {
              deletePet(id);
            Navigator.of(context).pop();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => PetsPage()),
                (Route<dynamic> route) => false); 
            },
          ),
        ),
      ],
    );
  }
}
  

