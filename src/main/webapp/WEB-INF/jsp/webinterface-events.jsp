<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--@elvariable id="util" type="sponsoren.Util"--%>
<%--@elvariable id="sponsor" type="sponsoren.orm.SponsorEntity"--%>
<%--@elvariable id="events" type="java.util.List<sponsoren.orm.VeranstaltungEntity>"--%>
<%--@elvariable id="locations" type="java.util.Map<Integer, sponsoren.orm.LocationEntity>"--%>
<%--@elvariable id="locationList" type="java.util.List<sponsoren.orm.LocationEntity>"--%>
<c:set var="context" value="${pageContext.request.contextPath}"/>

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

    <script src="${context}/js/api_client.js"></script>
    <script>api_set_context("${context}")</script>

    <title>Eigene Veranstaltungen - Sponsoren</title>

    <script>

        function sendVeranstaltung() {
            var resultElem = document.getElementById('veranstaltung-success-text');
            var resultInfoElem = document.getElementById('veranstaltung-info');

            resultElem.innerText = "";
            resultInfoElem.innerText = "";

            var name = document.getElementById('veranstaltung-name').value;
            var ort = document.getElementById('veranstaltung-ort').innerText;
            var start_date = document.getElementById('veranstaltung-start-date').value;
            var start_time = document.getElementById('veranstaltung-start-time').value;
            var ende_date = document.getElementById('veranstaltung-ende-date').value;
            var ende_time = document.getElementById('veranstaltung-ende-time').value;
            var beschreibung = document.getElementById('veranstaltung-beschreibung').value;
            var event_type;

            if (document.getElementById('radio_veranstaltung_send').checked)
                event_type = "Veranstaltung";
            else
                event_type = "Betriebsfeier";


            // make sure all fields are filled out
            if (name == "" || ort[0] == "[" || start_date == "" || start_time == "" || ende_date == "" || ende_time == "") {
                resultElem.style = "color: red;";
                resultElem.innerText = "Bitte alle Pflichtfelder ausfüllen!";
                return;
            }

            // save the data
            db_send_new_veranstaltung(name, ort, start_date, start_time, ende_date, ende_time, beschreibung, event_type).then(result => {
                if (result.ok) {

                    resultElem.style = "color: darkgreen;";
                    resultElem.innerText = "Veranstaltung erfolgreich erstellt!";

                    result.json().then(event => {
                        resultInfoElem.innerHTML =
                            "Name: " + event.name + "<br>" +
                            "Ort: " + event.ort + "<br>" +
                            "Zeitraum: " + event.start + " - " + event.ende + "<br>" +
                            (result.headers.has("Location") ?
                                '<a href="${context}' + result.headers.get("Location") + '" target="_blank">Zur Veranstaltungsseite gehen</a>'
                                : "") + "<br><br>";               // success
                        resultElem.style = "color: darkgreen;";

                    });

                    // clear out input fields
                    document.getElementById('veranstaltung-name').value = "";
                    document.getElementById('veranstaltung-ort').innerText = "[Veranstaltungsort]";
                    document.getElementById('veranstaltung-start-date').value = "";
                    document.getElementById('veranstaltung-start-time').value = "";
                    document.getElementById('veranstaltung-ende-date').value = "";
                    document.getElementById('veranstaltung-ende-time').value = "";
                    document.getElementById('veranstaltung-beschreibung').value = "";

                } else {
                    // error occurred
                    resultElem.style = "color: red;";

                    result.text().then(value => {
                        resultElem.innerText = "Es ist ein Fehler aufgetreten: " + result.status + " (" + value + ")";
                    });
                }
            });
        }

        function saveVeranstaltung(eventId) {
            // var name = document.getElementById('event' + eventId + '_name').innerText;
            var name = document.getElementById('veranstaltung' + eventId + '-name-edit').value;
            var beschreibung = document.getElementById('veranstaltung' + eventId + '-beschreibung-edit').value;
            var ort = document.getElementById('veranstaltung' + eventId + '-ort-edit').innerText;
            var start_date = document.getElementById('veranstaltung' + eventId + '-start-date-edit').value;
            var start_time = document.getElementById('veranstaltung' + eventId + '-start-time-edit').value;
            var ende_date = document.getElementById('veranstaltung' + eventId + '-ende-date-edit').value;
            var ende_time = document.getElementById('veranstaltung' + eventId + '-ende-time-edit').value;

            var event_type;
            if (document.getElementById('radio_' + eventId + '_ver').checked)
                event_type = "Veranstaltung";
            else
                event_type = "Betriebsfeier";

            var resultElem = document.getElementById('veranstaltung-edit-result-' + eventId);
            // make sure all fields are filled out
            if (name == "" || ort[0] == "[" || start_date == "" || start_time == "" || ende_date == "" || ende_time == "") {
                resultElem.style = "color: red;";
                resultElem.innerText = "Bitte alle Pflichtfelder ausfüllen!";
                return;
            }

            db_save_event_data(eventId, name, ort, start_date, start_time, ende_date, ende_time, beschreibung, event_type).then(result => {
                if (result.ok) {
                    // success
                    resultElem.style = "color: darkgreen;";
                    resultElem.innerText = "Änderungen gespeichert!";
                    document.getElementById("veranstaltung" + eventId + "-name").innerText = name;
                } else {
                    // error occurred
                    result.text().then(value => {
                        resultElem.style = "color: red;";
                        resultElem.innerText = "Es ist ein Fehler aufgetreten: " + result.status + " (" + value + ")";
                    });
                }
            });
        }

        function deleteVeranstaltung(eventId, eventName) {

            db_delete_veranstaltung(eventId).then(result => {
                if (result.ok) {
                    // success
                    var resultElem = document.getElementById('event-display-' + eventId);
                    resultElem.innerHTML = '<p style="color: darkgreen;">Veranstaltung "' + eventName + '" wurde erfolgreich entfernt!</p>'
                } else {
                    // error occurred
                    result.text().then(value => {
                        var resultElem = document.getElementById('veranstaltung-edit-result-' + eventId);
                        resultElem.style = "color: red;";
                        resultElem.innerText = "Es ist ein Fehler aufgetreten: " + result.status + " (" + value + ")";
                    });
                }
                // remove button
                // var button = document.getElementById('button-delete-veranstaltung-' + eventId);
                // button.parentNode.removeChild(button);
            });
        }

    </script>
    <style>
        .navbar-center {
            position: absolute;
            overflow: visible;
            height: 0;
            width: 100%;
            left: 0;
            top: 0;
            text-align: center;
        }
    </style>
</head>
<body>
<nav class="navbar fixed-top navbar-expand-lg navbar-dark bg-dark justify-content-center">
    <div class="pr-2">
        <a id="Sponsorenseitebutton" class="btn btn-light" href="${context}/webinterface"
           role="button">Sponsorenseite
        </a>
    </div>
    <div class="pr-2">
        <a id="Accountbutton" class="btn btn-light" href="${context}/webinterface/account"
           role="button">Account
        </a>
    </div>
    <ul class="nav navbar-nav ml-auto">
        <p class="navbar-text navbar-center text-white" style="font-size: x-large">Veranstaltungen verwalten</p>
        <div class="pr-2">
            <a id="Veranstaltungsbutton" class="btn btn-light disabled" href="${context}/webinterface/events"
               role="button" aria-disabled="true">Veranstaltungen
            </a>
        </div>
    </ul>
    <a id="logoutbutton" class="btn btn-danger" href="${context}/logout" role="button"><i
            class="fa fa-sign-out-alt"></i>
    </a>
</nav>
<div class="container pt-5">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body">

                    <h5 class="card-title">Veranstaltung hinzufügen</h5>
                    <div class="row col-12 mb-2">
                        <!-- Betriebsfeier/Veranstaltung-->
                        <div class="input-group input-group-toggle" data-toggle="buttons">
                            <label class="btn btn-light active">
                                <input type="radio" name="set_event_type" id="radio_veranstaltung_send" autocomplete="off" checked>
                                Öffentliche Veranstaltung
                            </label>
                            <label class="btn btn-light">
                                <input type="radio" name="set_event_type" id="radio_betriebsfeier_send" autocomplete="off">
                                Betriebsfeier
                            </label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-6 mb-3" style="width: 100%;">
                            <input id="veranstaltung-name" type="text" placeholder="Name" class="form-control">
                        </div>
                        <div class="col-6 mb-3">
                            <div class="input-group">
                                <div class="input-group-prepend">
                                    <span class="input-group-text"><i class="fas fa-thumbtack"></i></span>
                                </div>
                                <button id="veranstaltung-ort" class="btn btn-outline-secondary dropdown-toggle" type="button" data-toggle="dropdown">
                                    [Veranstaltungsort]
                                </button>
                                <div class="dropdown-menu" style="height: 400px; overflow: auto;">
                                    <c:forEach items="${locationList}" var="location">
                                        <button class="dropdown-item"
                                                onclick="document.getElementById('veranstaltung-ort').innerText='${location.name}'">${location.name}
                                        </button>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </div>


                    <!-- Veranstaltung Start -->
                    <div class="row">
                        <div class="col-6">
                            <div class="input-group">
                                <div class="input-group-prepend">
                                    <span class="input-group-text">Start</span>
                                    <span class="input-group-text"><i class="far fa-calendar-alt"></i></span>
                                </div>
                                <input id="veranstaltung-start-date" type="date"
                                       placeholder="dd/mm/yyyy HH:MM (Datum+Uhrzeit)"
                                       class="form-control" style="min-width: 155px;">
                                <div class="input-group-append pl-1">
                                    <span class="input-group-text"><i class="far fa-clock"></i></span>
                                </div>
                                <input id="veranstaltung-start-time" type="time" class="form-control pr-0"
                                       placeholder="Zeit HH:MM">
                            </div>
                        </div>
                        <!-- Veranstaltung Ende -->
                        <div class="col-6">
                            <div class="input-group">
                                <div class="input-group-prepend">
                                    <span class="input-group-text">Ende</span>
                                    <span class="input-group-text"><i class="far fa-calendar-alt"></i></span>
                                </div>
                                <input id="veranstaltung-ende-date" type="date"
                                       placeholder="dd/mm/yyyy HH:MM (Datum+Uhrzeit)"
                                       class="form-control" style="min-width: 155px;">
                                <div class="input-group-append pl-1">
                                    <span class="input-group-text"><i class="far fa-clock"></i></span>
                                </div>
                                <input id="veranstaltung-ende-time" type="time" class="form-control"
                                       placeholder="Zeit HH:MM">
                            </div>
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col-12">
                            <textarea id="veranstaltung-beschreibung" class="form-control" rows="5"
                                      placeholder="Beschreibung der Veranstaltung"></textarea>
                        </div>
                        <br>
                        <div class="col-12 mt-1">
                            <div class="text-center">
                                <a class="btn btn-primary btn-block" href="#" onclick="sendVeranstaltung();" role="button">
                                    Veranstaltung veröffentlichen
                                </a>

                                <br>
                                <p id="veranstaltung-success-text"></p>
                                <div id="veranstaltung-info"></div>

                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>


<!------------------ Veranstaltungen bearbeiten ------------------>
<c:if test="${events.size() > 0}">
    <div class="container pt-5">
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="row">
                        <div class="col-12">
                            <div class="card-body">
                                <h5 class="card-title">Veranstaltungen editieren</h5>
                            </div>
                        </div>
                        <c:forEach items="${events}" var="event">
                            <div class="col-12 col-md-6" id="event-display-${event.id}">
                                <div class="card-body">
                                    <h5 class="card-title">
                                        <a id="veranstaltung${event.id}-name" href="${context}/event?id=${event.id}" class="text-decoration-none">
                                                ${event.name}
                                        </a>
                                    </h5>

                                    <!-- Betriebsfeier/Veranstaltung Edit -->
                                    <div class="input-group input-group-toggle" data-toggle="buttons">
                                        <label class="btn btn-light active">
                                            <input type="radio" name="edit_${event.id}" id="radio_${event.id}_ver" autocomplete="off"
                                                   <c:if test="${event.discriminator=='Veranstaltung'}">checked</c:if>>
                                            Öffentliche Veranstaltung
                                        </label>
                                        <label class="btn btn-light">
                                            <input type="radio" name="edit_${event.id}" id="radio_${event.id}_betr" autocomplete="off"
                                                   <c:if test="${event.discriminator=='Betriebsfeier'}">checked</c:if>>
                                            Betriebsfeier
                                        </label>
                                    </div>

                                    <!-- Name Edit -->
                                    <div class="input-group-prepend">
                                        <span class="input-group-text">Name</span>
                                        <input id="veranstaltung${event.id}-name-edit" type="text"
                                               value="${event.name}"
                                               placeholder="" class="form-control"
                                               aria-label="Sizing example input"
                                               aria-describedby="inputGroup-sizing-sm">
                                    </div>

                                    <!-- Beschreibung Edit -->
                                    <div class="input-group-prepend">
                                        <span class="input-group-text">Kurzbeschreibung</span>
                                        <input id="veranstaltung${event.id}-beschreibung-edit" type="text"
                                               value="${event.beschreibung}"
                                               placeholder="" class="form-control"
                                               aria-label="Sizing example input"
                                               aria-describedby="inputGroup-sizing-sm">
                                    </div>

                                    <!-- Sponsor Hinzufügen -->
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text"><i class="fas fa-plus"></i></span>
                                        </div>
                                        <button id="veranstaltung${event.id}-ort-edit"
                                                class="btn btn-outline-secondary dropdown-toggle"
                                                type="button" data-toggle="dropdown" aria-haspopup="true"
                                                aria-expanded="false">[Sponsor hinzufügen]</button>
                                        <div class="dropdown-menu" style="height: 400px; overflow: auto;">
                                            <c:forEach items="${locationList}" var="location">
                                                <button class="dropdown-item"
                                                        onclick="document.getElementById('veranstaltung${event.id}-ort-edit').innerText='${location.name}'">${location.name}</button>
                                            </c:forEach>
                                        </div>
                                    </div>

                                    <!-- Ort Edit -->
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text">Ort</span>
                                            <span class="input-group-text"><i class="fas fa-thumbtack"></i></span>
                                        </div>
                                        <button id="veranstaltung${event.id}-ort-edit"
                                                class="btn btn-outline-secondary dropdown-toggle"
                                                type="button" data-toggle="dropdown" aria-haspopup="true"
                                                aria-expanded="false">${locations.get(event.locationID).name}</button>
                                        <div class="dropdown-menu" style="height: 400px; overflow: auto;">
                                            <c:forEach items="${locationList}" var="location">
                                                <button class="dropdown-item"
                                                        onclick="document.getElementById('veranstaltung${event.id}-ort-edit').innerText='${location.name}'">${location.name}</button>
                                            </c:forEach>
                                        </div>
                                    </div>

                                    <!-- Start Edit -->
                                    <div class="input-group-prepend">
                                        <span class="input-group-text">Start</span>
                                        <span class="input-group-text"><i class="far fa-calendar-alt"></i></span>
                                        <input id="veranstaltung${event.id}-start-date-edit" type="date"
                                               value="${util.parsableDateForHTML(event.start)}"
                                               placeholder="dd/mm/yyyy HH:MM (Datum+Uhrzeit)"
                                               class="form-control" aria-label="Veranstaltung Start Datum"
                                               aria-describedby="inputGroup-sizing-sm">
                                        <div class="input-group-append">
                                            <span class="input-group-text"><i class="far fa-clock"></i></span>
                                        </div>
                                        <input id="veranstaltung${event.id}-start-time-edit" type="time"
                                               class="form-control"
                                               value="${util.parsableTimeForHTML(event.start)}"
                                               placeholder="Zeit HH:MM"
                                               aria-label="Start-Time" aria-describedby="basic-addon1">
                                    </div>

                                    <!-- Ende Edit -->
                                    <div class="input-group-prepend">
                                        <span class="input-group-text">Ende</span>
                                        <span class="input-group-text"><i class="far fa-calendar-alt"></i></span>
                                        <input id="veranstaltung${event.id}-ende-date-edit" type="date"
                                               value="${util.parsableDateForHTML(event.ende)}"
                                               placeholder="dd/mm/yyyy HH:MM (Datum+Uhrzeit)"
                                               class="form-control" aria-label="Veranstaltung Start Datum"
                                               aria-describedby="inputGroup-sizing-sm">
                                        <div class="input-group-append">
                                            <span class="input-group-text"><i class="far fa-clock"></i></span>
                                        </div>
                                        <input id="veranstaltung${event.id}-ende-time-edit" type="time" class="form-control"
                                               value="${util.parsableTimeForHTML(event.ende)}"
                                               placeholder="Zeit HH:MM"
                                               aria-label="Start-Time" aria-describedby="basic-addon1">
                                    </div>

                                    <!-- Speichern Button -->
                                    <button id="button-save-veranstaltung-${event.id}" class="btn btn-primary btn-success mt-1"
                                            onclick="saveVeranstaltung(${event.id})" role="button">
                                        Änderungen speichern
                                    </button>

                                    <!-- Löschen Button -->
                                    <button type="button" class="btn btn-danger mt-1" data-toggle="modal" data-target="#delete-modal-${event.id}">
                                        Löschen
                                    </button>

                                    <!-- Löschen Bestätigungs-Modal -->
                                    <div class="modal fade" id="delete-modal-${event.id}" tabindex="-1" role="dialog">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h5 class="modal-title">Bestätigen</h5>
                                                    <button type="button" class="close" data-dismiss="modal">
                                                        <span aria-hidden="true">&times;</span>
                                                    </button>
                                                </div>
                                                <div class="modal-body">
                                                    Soll die Veranstaltung wirklich gelöscht werden?
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">
                                                        Abbrechen
                                                    </button>
                                                    <button type="button" class="btn btn-danger"
                                                            onclick="deleteVeranstaltung(${event.id}, '${event.name}');"
                                                            data-dismiss="modal">Löschen
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <p id="veranstaltung-edit-result-${event.id}"></p>
                                </div>
                            </div>
                        </c:forEach>

                    </div>
                </div>
            </div>
        </div>
    </div>
</c:if>


<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
        integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
        crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"
        integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1"
        crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
        integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM"
        crossorigin="anonymous"></script>
</body>
</html>
