import 'package:flutter/material.dart';
import 'package:nbea/services/network.dart';
import 'package:nbea/services/urls.dart';
import 'package:nbea/json/jsons.dart';
import 'package:provider/provider.dart';
import 'package:nbea/components/games_widgets/gamelst.dart';
import 'package:nbea/components/connection.dart';

class Games extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider.of<JsonFiles>(context, listen: false).getGames() == null
        ? FutureBuilder(
            future: Network.getJson(Urls.seasonGames),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                Provider.of<JsonFiles>(context, listen: false)
                    .setGames(snapshot.data);
                dynamic json = snapshot.data;
                return SeasonGames(
                  jsonFile: json,
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.replay_rounded,
                        size: 50,
                      ),
                      Text("Click to refresh"),
                    ],
                  ),
                );
              } else if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            })
        : SeasonGames(
            jsonFile: Provider.of<JsonFiles>(context).getGames(),
          );
  }
}
