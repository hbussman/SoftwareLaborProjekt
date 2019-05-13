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
            var start = document.getElementById('veranstaltung-start').value;
            var ende = document.getElementById('veranstaltung-ende').value;
            var beschreibung = document.getElementById('veranstaltung-beschreibung').value;

            // make sure all fields are filled out
            if (name == "" || ort[0] == "[" || start == "" || ende == "") {
                resultElem.style = "color: red;";
                resultElem.innerText = "Bitte alle Pflichtfelder ausfüllen! " + name + "|" + ort + "|" + start + "|" + ende + "|";
                return;
            }

            db_send_new_veranstaltung(username, name, ort, start, ende, beschreibung).then(result => {
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
                    document.getElementById('veranstaltung-start').value = "";
                    document.getElementById('veranstaltung-ende').value = "";
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
            var beschreibung = document.getElementById('event' + eventId + '_beschreibung').value;
            var ort = document.getElementById('event' + eventId + '_ort').innerText;
            var start = document.getElementById('event' + eventId + '_start').value;
            var ende = document.getElementById('event' + eventId + '_ende').value;

            db_save_event_data(getCookie('username'), eventId, beschreibung, ort, start, ende).then(result => {
                if (result.ok) {
                    // success
                    var resultElem = document.getElementById('event-action-result-' + eventId);
                    resultElem.style = "color: darkgreen;";
                    resultElem.innerText = "Änderungen gespeichert!";
                } else {
                    // error occurred
                    result.text().then(value => {
                        var resultElem = document.getElementById('event-action-result-' + eventId);
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
                        var resultElem = document.getElementById('event-action-result-' + eventId);
                        resultElem.style = "color: red;";
                        resultElem.innerText = "Es ist ein Fehler aufgetreten: " + result.status + " (" + value + ")";
                    });
                }
                // remove button
                var button = document.getElementById('button-delete-event-' + eventId);
                button.parentNode.removeChild(button);
            });
        }
    </script>

</head>
<body onload="Init()">
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <a class="navbar-brand" style="color: whitesmoke">Sponsoren-Webinterface</a>
    <ul class="nav navbar-nav ml-auto">
    </ul>
    <div class="pr-2">
        <a class="btn btn-primary btn-secondary" href="${context}/webinterface" role="button">Sponsorseite
        </a>
    </div>
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
                        <div class="col-6">
                            <div class="input-group mb-3">
                            <div class="input-group-prepend">
                                <span class="input-group-text">Start</span>
                                <span class="input-group-text"><i class="far fa-calendar-alt"></i></span>
                                <input id="veranstaltung-start" type="date"
                                       placeholder="dd/mm/yyyy HH:MM (Datum+Uhrzeit)"
                                       class="form-control" aria-label="Veranstaltung Start"
                                       aria-describedby="inputGroup-sizing-sm">
                                <div class="input-group-append">
                                    <span class="input-group-text"><i class="far fa-clock"></i></span>
                                </div>
                                <input type="text" class="form-control" placeholder="Zeit HH:MM" aria-label="Start-Time" aria-describedby="basic-addon1">
                            </div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="input-group mb-3">
                                <div class="input-group-prepend">
                                    <span class="input-group-text">Ende</span>
                                    <span class="input-group-text"><i class="far fa-calendar-alt"></i></span>
                                    <input id="veranstaltung-ende" type="date"
                                           placeholder="dd/mm/yyyy HH:MM (Datum+Uhrzeit)"
                                           class="form-control" aria-label="Veranstaltung Start"
                                           aria-describedby="inputGroup-sizing-sm">
                                    <div class="input-group-append">
                                        <span class="input-group-text"><i class="far fa-clock"></i></span>
                                    </div>
                                    <input type="text" class="form-control" placeholder="Zeit HH:MM" aria-label="Start-Time" aria-describedby="basic-addon1">
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
                                    <a id="event${event.id}_name" href="${context}/event?id=${event.id}"
                                       class="text-decoration-none">${event.name}</a>
                                </h5>

                                <!-- Beschreibung Edit -->
                                <div class="input-group-prepend">
                                    <span class="input-group-text">Kurzbeschreibung</span>
                                    <input id="event${event.id}_beschreibung" type="text"
                                           value="${event.beschreibung}"
                                           placeholder="" class="form-control"
                                           aria-label="Sizing example input"
                                           aria-describedby="inputGroup-sizing-sm">
                                </div>

                                <!-- Ort Edit -->
                                <div class="input-group-prepend">
                                    <span class="input-group-text">Ort</span>
                                    <button id="event${event.id}_ort" class="btn btn-outline-secondary dropdown-toggle"
                                            type="button" data-toggle="dropdown" aria-haspopup="true"
                                            aria-expanded="false">${locations.get(event.locationID).name}</button>
                                    <div class="dropdown-menu">
                                        <c:forEach items="${locationList}" var="location">
                                            <button class="dropdown-item"
                                                    onclick="document.getElementById('event${event.id}_ort').innerText='${location.name}'">${location.name}</button>
                                        </c:forEach>
                                    </div>
                                </div>

                                <!-- Start Edit -->
                                <div class="input-group-prepend">
                                    <span class="input-group-text">Start</span>
                                    <input id="event${event.id}_start" type="date"
                                           value="${util.parsableDatetimeForHTML(event.start)}"
                                           placeholder="dd/mm/yyyy"
                                           class="form-control" aria-label="Veranstaltung Start"
                                           aria-describedby="inputGroup-sizing-sm">
                                </div>


                                <!-- Ende Edit -->
                                <div class="input-group-prepend">
                                    <span class="input-group-text">Ende</span>
                                    <input id="event${event.id}_ende" type="datetime-local"
                                           value="${util.parsableDatetimeForHTML(event.ende)}"
                                           placeholder="dd/mm/yyyy HH:MM (Datum+Uhrzeit)"
                                           class="form-control" aria-label="Veranstaltung Ende"
                                           aria-describedby="inputGroup-sizing-sm">
                                </div>

                                <script>
                                    function onClickDelete${event.id}() {
                                        var button = document.getElementById('button-delete-event-${event.id}');
                                        if (button.innerText === "WIRKLICH?") {
                                            deleteVeranstaltung(${event.id}, '${event.name}');
                                        } else {
                                            button.innerText = "WIRKLICH?";
                                            button.className = "btn btn-primary btn-warning";
                                        }
                                    }
                                </script>
                                <button id="button-save-event-${event.id}" class="btn btn-primary btn-success"
                                        onclick="saveVeranstaltung(${event.id});" role="button">Änderungen speichern
                                </button>
                                <button id="button-delete-event-${event.id}" class="btn btn-primary btn-danger"
                                        onclick="onClickDelete${event.id}();" role="button">Löschen
                                </button>
                                <p id="event-action-result-${event.id}"></p>
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
