<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--@elvariable id="util" type="sponsoren.Util"--%>
<%--@elvariable id="sponsor" type="sponsoren.orm.SponsorEntity"--%>
<%--@elvariable id="sponsorEvents" type="java.util.List<sponsoren.orm.VeranstaltungEntity>"--%>
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

    <script src="${context}/js/util.js"></script>
    <script src="${context}/js/api_client.js"></script>
    <script>api_set_context("${context}")</script>

    <title>Eigene Veranstaltungen - Sponsoren</title>

    <script>
        function Init() {
            var username = getCookie("username");
        }

        function sendVeranstaltung() {
            var username = getCookie("username");
            console.log("send veranstaltung of " + username);

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

            // make sure all fields are filled out
            if (name == "" || ort[0] == "[" || start_date == "" || start_time == "" || ende_date == "" || ende_time == "") {
                resultElem.style = "color: red;";
                resultElem.innerText = "Bitte alle Pflichtfelder ausfüllen!";
                return;
            }

            // save the data
            db_send_new_veranstaltung(username, name, ort, start_date, start_time, ende_date, ende_time, beschreibung).then(result => {
                if (result.ok) {
                    // success
                    resultElem.style = "color: darkgreen;";
                    resultElem.innerText = "Veranstaltung erfolgreich erstellt!";

                    result.json().then(event => {
                        resultInfoElem.innerHTML =
                            "Name: " + event.name + "<br>" +
                            "Ort: " + event.ort + "<br>" +
                            "Zeitraum: " + event.start + " - " + event.ende + "<br>" +
                            (result.headers.has("Location") ?
                                '<a href="${context}' + result.headers.get("Location") + '" target="_blank">Zur Veranstaltungsseite gehen</a>'
                                : "");
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

            var resultElem = document.getElementById('veranstaltung-edit-result-' + eventId);
            // make sure all fields are filled out
            if (name == "" || ort[0] == "[" || start_date == "" || start_time == "" || ende_date == "" || ende_time == "") {
                resultElem.style = "color: red;";
                resultElem.innerText = "Bitte alle Pflichtfelder ausfüllen!";
                return;
            }

            db_save_event_data(getCookie('username'), eventId, name, beschreibung, ort, start_date, start_time, ende_date, ende_time).then(result => {
                if (result.ok) {
                    // success
                    resultElem.style = "color: darkgreen;";
                    resultElem.innerText = "Änderungen gespeichert!";
                    document.getElementById("veranstaltung"+eventId+"-name").innerText = name;
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

            db_delete_veranstaltung(eventId, '${sponsor.name}').then(result => {
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
        .navbar-center
        {
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
<body onload="Init()">
<nav class="navbar navbar-expand-lg navbar-dark bg-dark justify-content-center">
    <div class="pr-2">
        <a class="btn btn-primary btn-secondary" href="${context}/webinterface/home?sponsor=${sponsor.name}"
           role="button">Sponsorenseite
        </a>
    </div>
    <div class="pr-2">
    <a class="btn btn-primary btn-secondary" href="${context}/webinterface/account?sponsor=${sponsor.name}"
       role="button">Account
    </a>
</div>
    <ul class="nav navbar-nav ml-auto">
    <p class="navbar-text navbar-center text-white">Veranstaltungen verwalten</p>
    <div class="pr-2">
        <a class="btn btn-primary btn-secondary disabled" href="${context}/webinterface/events?sponsor=${sponsor.name}"
           role="button" aria-disabled="true">Veranstaltungen
        </a>
    </div>
</ul>
    <a class="btn btn-primary btn-danger" href="${context}/webinterface/login" role="button"><i
            class="fa fa-sign-out-alt"></i>
    </a>
</nav>
<div class="container">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Veranstaltung hinzufügen</h5>
                    <div class="input-group input-group-sm mb-3">
                        <div class="row">
                            <div class="col-6">
                                <input id="veranstaltung-name" type="text" placeholder="Name" class="form-control"
                                       aria-label="Sizing example input" aria-describedby="inputGroup-sizing-sm">
                            </div>
                            <div class="col-6">
                                <div class="input-group-prepend">
                                    <span class="input-group-text"><i class="fas fa-thumbtack"></i></span>
                                    <button id="veranstaltung-ort" class="btn btn-outline-secondary dropdown-toggle"
                                            type="button" data-toggle="dropdown" aria-haspopup="true"
                                            aria-expanded="false">[Veranstaltungsort]
                                    </button>
                                    <div class="dropdown-menu">
                                        <c:forEach items="${locationList}" var="location">
                                            <button class="dropdown-item"
                                                    onclick="document.getElementById('veranstaltung-ort').innerText='${location.name}'">${location.name}</button>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <!-- Veranstaltung Start -->
                        <div class="col-6">
                            <div class="input-group mb-3">
                            <div class="input-group-prepend">
                                <span class="input-group-text">Start</span>
                                <span class="input-group-text"><i class="far fa-calendar-alt"></i></span>
                                <input id="veranstaltung-start-date" type="date"
                                       placeholder="dd/mm/yyyy HH:MM (Datum+Uhrzeit)"
                                       class="form-control" aria-label="Veranstaltung Start Datum"
                                       aria-describedby="inputGroup-sizing-sm">
                                <div class="input-group-append">
                                    <span class="input-group-text"><i class="far fa-clock"></i></span>
                                </div>
                                <input id="veranstaltung-start-time" type="time" class="form-control" placeholder="Zeit HH:MM" aria-label="Veranstaltung Start Zeit" aria-describedby="basic-addon1">
                            </div>
                            </div>
                        </div>
                        <!-- Veranstaltung Ende -->
                        <div class="col-6">
                            <div class="input-group mb-3">
                                <div class="input-group-prepend">
                                    <span class="input-group-text">Ende</span>
                                    <span class="input-group-text"><i class="far fa-calendar-alt"></i></span>
                                    <input id="veranstaltung-ende-date" type="date"
                                           placeholder="dd/mm/yyyy HH:MM (Datum+Uhrzeit)"
                                           class="form-control" aria-label="Veranstaltung Ende Datum"
                                           aria-describedby="inputGroup-sizing-sm">
                                    <div class="input-group-append">
                                        <span class="input-group-text"><i class="far fa-clock"></i></span>
                                    </div>
                                    <input id="veranstaltung-ende-time" type="time" class="form-control" placeholder="Zeit HH:MM" aria-label="Veranstaltung Ende Zeit" aria-describedby="basic-addon1">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-12">
                    <textarea id="veranstaltung-beschreibung" class="form-control" rows="5"
                              placeholder="Beschreibung der Veranstaltung"></textarea>
                </div>
                <br>
                <div class="col-12">
                    <div class="text-center">
                        <a class="btn btn-primary btn-block" href="#" onclick="sendVeranstaltung();" role="button">Veranstaltung
                            veröffentlichen</a>
                        <br>
                        <p id="veranstaltung-success-text"></p>
                        <div id="veranstaltung-info"></div>
                        <br>
                        <br>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12">
                        <div class="card-body">
                            <c:if test="${sponsorEvents.size() > 0}">
                                <h2 class="text-start">Veranstaltungen von ${sponsor.name}</h2>
                            </c:if>
                        </div>
                    </div>
                    <c:forEach items="${sponsorEvents}" var="event">
                        <div class="col-12 col-md-6" id="event-display-${event.id}">
                            <div class="card-body">
                                <h5 class="card-title">
                                    <a id="veranstaltung${event.id}-name" href="${context}/event?id=${event.id}"
                                       class="text-decoration-none">${event.name}</a>
                                </h5>

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

                                <!-- Ort Edit -->
                                <div class="input-group-prepend">
                                    <span class="input-group-text">Ort</span>
                                    <span class="input-group-text"><i class="fas fa-thumbtack"></i></span>
                                    <button id="veranstaltung${event.id}-ort-edit" class="btn btn-outline-secondary dropdown-toggle"
                                            type="button" data-toggle="dropdown" aria-haspopup="true"
                                            aria-expanded="false">${locations.get(event.locationID).name}</button>
                                    <div class="dropdown-menu">
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
                                    <input id="veranstaltung${event.id}-start-time-edit" type="time" class="form-control"
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

                                <script>
                                    function onClickDelete${event.id}() {
                                        var button = document.getElementById('button-delete-veranstaltung-${event.id}');
                                        if (button.innerText === "WIRKLICH?") {
                                            deleteVeranstaltung(${event.id}, '${event.name}');
                                        } else {
                                            button.innerText = "WIRKLICH?";
                                            button.className = "btn btn-primary btn-warning";
                                        }
                                    }
                                </script>
                                <button id="button-save-veranstaltung-${event.id}" class="btn btn-primary btn-success"
                                        onclick="saveVeranstaltung(${event.id})" role="button">Änderungen speichern
                                </button>
                                <button id="button-delete-veranstaltung-${event.id}" class="btn btn-primary btn-danger"
                                        onclick="onClickDelete${event.id}();" role="button">Löschen
                                </button>
                                <p id="veranstaltung-edit-result-${event.id}"></p>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

        </div>
    </div>
</div>
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
