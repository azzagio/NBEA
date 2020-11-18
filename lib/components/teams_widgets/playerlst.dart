import 'package:flutter/material.dart';
import 'package:nbea/json/jsons.dart';
import 'package:nbea/components/teams_widgets/roster.dart';
import 'package:nbea/services/network.dart';
import 'package:nbea/services/urls.dart';
import 'package:provider/provider.dart';

class PlayerList extends StatelessWidget {
  final String teamId;
  PlayerList({this.teamId});
  @override
  Widget build(BuildContext context) {
    return Provider.of<JsonFiles>(context, listen: false)
                .getTeamRoster(teamId) ==
            null
        ? FutureBuilder<dynamic>(
            future: Network.getJson(Urls.teamPlayersUrl(teamId)),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              Widget playerList;
              if (snapshot.hasData) {
                Provider.of<JsonFiles>(context, listen: false).addTeamPlayers(
                    teamId, snapshot.data); // add teamRoster json to Provider
                playerList = Roster(
                  json: snapshot.data,
                );
              } else if (snapshot.hasError) {
                playerList = Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error,
                      size: 50,
                    ),
                    Text("Something went wrong!"),
                  ],
                );
              } else {
                playerList = Center(
                  child: CircularProgressIndicator(),
                );
              }
              return playerList;
            },
          )
        : Roster(
            json: Provider.of<JsonFiles>(context, listen: false)
                .getTeamRoster(teamId),
          );
  }
}
