<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
          integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css"
          integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf" crossorigin="anonymous">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.8.0/css/bootstrap-datepicker.min.css"
          crossorigin="anonymous">


    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
            integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
            crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"
            integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1"
            crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
            integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM"
            crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.8.0/js/bootstrap-datepicker.min.js"
            crossorigin="anonymous"></script>


    <script src="/js/util.js"></script>
    <script src="/js/api_client.js"></script>

    <title>Webinterface-logo</title>

    <script>
        var SponsorData;

        function Init() {
            var username = getCookie("username");

            // ask database for information
            db_get_sponsor_info(username).then(function (json_info) {
                console.log(json_info);
                document.getElementById("info_text").value = json_info["beschreibung"];

                SponsorData = json_info;
            });
        }

        function Save() {
            console.log("Save " + SponsorData);
            SponsorData["beschreibung"] = document.getElementById("info_text").value;

            db_save_sponsor_info(SponsorData).then(function (value) {
                console.log(value.status);
                var resDiv = document.getElementById("ResultStatus");
                if(value.status == 200) {
                    resDiv.innerHTML = '<p style="color:darkgreen;">Success!</p>';
                } else {
                    resDiv.innerText = '<p style="color:darkred;">Request failed! Status=' + value.status + '</p>';
                }
            })
        }

        function sendVeranstaltung() {
            var username = getCookie("username");
            console.log("send veranstaltung of " + username);

            var resultElem = document.getElementById('veranstaltung-success-text');

            var name = document.getElementById('veranstaltung-name').value;
            var ort = document.getElementById('veranstaltung-ort').value;
            var start = document.getElementById('veranstaltung-start').value;
            var ende = document.getElementById('veranstaltung-ende').value;

            // make sure all fields are filled out
            if(name == "" || ort == "" || start == "" || ende == "") {
                resultElem.style = "color: red;";
                resultElem.innerText = "Bitte alle Felder ausfüllen!";
                return;
            }

            db_send_new_veranstaltung(username, name, ort, start, ende).then(result => {
                if(result.ok) {
                    // success
                    resultElem.style = "color: darkgreen;";
                    resultElem.innerText = "Veranstaltung erfolgreich erstellt!";
                    document.getElementById('veranstaltung-info').innerHTML =
                            "Name: " + name + "<br>" +
                            "Ort: " + ort + "<br>" +
                            "Zeitraum: " + start + " - " + ende + "<br>" +
                            (result.headers.has("Location") ?
                                '<a href="' + result.headers.get("Location") + '" target="_blank">Zur Veranstaltungsseite gehen</a>'
                                : "");

                    // clear out input fields
                    document.getElementById('veranstaltung-name').value = "";
                    document.getElementById('veranstaltung-ort').value = "";
                    document.getElementById('veranstaltung-start').value = "";
                    document.getElementById('veranstaltung-ende').value = "";

                } else {
                    // error occurred
                    resultElem.style = "color: red;";

                    result.text().then(value => {
                        resultElem.innerText = "Es ist ein Fehler aufgetreten: " + result.status + " (" +
                            value + ")";
                    });
                }
            });
        }

    </script>

</head>
<body onload="Init()">
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <a class="navbar-brand" href="/webinterface/home">Persönliche Seite</a>
    <ul class="navbar-nav mr-auto mt-2 mt-lg-0">
        <li class="nav-item active ml-1">
            <a class="nav-link" href="/webinterface/login">
                <i class="fa fa-sign-out-alt"></i>
                <span class="sr-only">(current)</span></a>
        </li>
    </ul>
</nav>
<div class="container mt-2">
    <div class="row">
        <div class="col-lg-4 col-md-4 col-sm-12">
            <div class="card" style="width:100%">
                <p class="card-title">Neue Veranstaltung erstellen</p>
                <div class="text-center">
                    <div class="input-group input-group mb-3">
                        <div class="input-group-prepend">
                            <span class="input-group-text" id="inputGroup-sizing-sm">Name</span>
                        </div>
                        <input id="veranstaltung-name" type="text" class="form-control" aria-label="Sizing example input"
                               aria-describedby="inputGroup-sizing-sm">
                    </div>

                    <div class="input-group mb-3">
                        <div class="input-group-prepend">
                            <span class="input-group-text" id="inputGroup-sizing-default">Ort</span>
                        </div>
                        <input id="veranstaltung-ort" type="text" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-default">
                    </div>

                    <div class="input-group input-group mb-3">
                        <div class="input-group-prepend">
                            <span class="input-group-text" id="inputGroup-sizing-lg">Start-Datum</span>
                        </div>
                        <input id="veranstaltung-start" data-provide="datepicker" type="text" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-lg">
                    </div>

                    <div class="input-group input-group mb-3">
                        <div class="input-group-prepend">
                            <span class="input-group-text" id="inputGroup-sizing-lg">End-Datum</span>
                        </div>
                        <input id="veranstaltung-ende" data-provide="datepicker" type="text" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-lg">
                    </div>

                    <p style="" id="veranstaltung-success-text"></p>
                    <div id="veranstaltung-info"></div>
                </div>
                <div class="card-body">
                    <a href="#" class="btn btn-dark" onclick="sendVeranstaltung();">Veranstaltung hinzufügen</a>
                </div>
            </div>
        </div>
        <div class="offset-lg-0 col-lg-8 offset-md-2 col-md-6 col-sm-12">
            <div class="form-group">
                <textarea id="info_text" class="form-control" rows="11"
                          placeholder="Sponsoren Info-Text" aria-label="Username"
                          aria-describedby="basic-addon1"></textarea>
                <div class="card-body">
                    <a href="#" class="btn btn-dark" onclick="Save()">Text ändern</a>
                </div>
                <div id="ResultStatus"></div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
