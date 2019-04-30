<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--@elvariable id="sponsor" type="sponsoren.orm.SponsorEntity"--%>

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

    <script src="/js/util.js"></script>
    <script src="/js/api_client.js"></script>

    <title>Persönloche Seite - Sponsoren</title>

    <script>
        function Init() {
            var username = getCookie("username");
        }
    </script>

</head>
<body onload="Init()">
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <a class="navbar-brand" style="color: whitesmoke">Sponsoren-Webinterface</a>
            <ul class="nav navbar-nav ml-auto">
                <li><button type="submit" class="btn navbar-btn btn-danger" name="logout" id="logout"  value="Log Out">
                    <i class="fa fa-sign-out-alt"></i></button>
                </li>
            </ul>
</nav>
<div class="container">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="text-center">
                    <img src="img/${sponsor.name}_scaled.png" style="max-height: 250px; max-width: 250px" class="card-img-thumbnail" alt="...">
                </div>
                <div class="card-body">
                    <h5 class="card-title">${sponsor.name}</h5>
                    <textarea id="sponsor_beschreibung" class="form-control" rows="8"
                              placeholder="Sponsoren Info-Text" aria-label="Username"
                              aria-describedby="basic-addon1">${sponsor.beschreibung}</textarea>
                </div>
                <div class="card-body">
                    <h5 class="card-title">Werbetext</h5>
                    <textarea id="sponsor_werbetext" class="form-control" rows="5"
                              placeholder="Sponsoren Info-Text" aria-label="Username"
                              aria-describedby="basic-addon1">${sponsor.werbetext}</textarea>
                </div>
                <div class="card-body">
                    <h5 class="card-title">Kontakt</h5>
                    <div class="input-group input-group-sm mb-3">
                        <div class="row">
                            <div class="col-6">
                                <input type="text" placeholder="Vorname" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-sm">${sponsor.ansprechpartnerVorname}
                            </div>
                            <div class="col-6">
                                <input type="text" placeholder="Nachname" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-sm">${sponsor.ansprechpartnerNachname}
                            </div>
                        </div>
                    </div>
                    <div class="input-group input-group-sm mb-3">
                        <div class="row">
                            <div class="col-4">
                                <input type="text" placeholder="Email" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-sm">${sponsor.email}
                            </div>
                            <div class="col-4">
                                <input type="text" placeholder="Telefonnummer" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-sm">${sponsor.telefonnummer}
                            </div>
                            <div class="col-4">
                                <input type="text" placeholder="Adresse" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-sm">${sponsor.adresse}
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12">
                        <div class="card-body">
                            <h2 class="text-start">Veranstaltungen</h2>
                        </div>
                    </div>
                    <c:forEach items="${sponsorEvents}" var="event">
                        <div class="col-12 col-md-6">
                            <div class="card-body">
                                <h5 class="card-title"><a href="/event?id=${event.id}" class="text-decoration-none">${event.name}</a></h5>
                                <p class="card-text">${event.beschreibung}</p>
                                <p class="card-text">Ort: ${locations.get(event.locationID).name}</p>
                                <p class="card-text">Zeit: ${util.prettifyTimestamp(event.start)} bis ${util.prettifyTimestamp(event.ende)}</p>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                <div class="card-body">
                    <h5 class="card-title">Veranstaltung hinzufügen</h5>
                    <div class="input-group input-group-sm mb-3">
                        <div class="row">
                            <div class="col-3">
                                <input type="text" placeholder="Name" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-sm">
                            </div>
                                <div class="col-3">
                                <div class="input-group-prepend">
                                    <button class="btn btn-outline-secondary dropdown-toggle" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Veranstaltungsort</button>
                                    <div class="dropdown-menu">
                                        <a class="dropdown-item" href="#">Action</a>
                                        <a class="dropdown-item" href="#">Another action</a>
                                        <a class="dropdown-item" href="#">Something else here</a>
                                        <div role="separator" class="dropdown-divider"></div>
                                        <a class="dropdown-item" href="#">Separated link</a>
                                    </div>
                                </div>
                                </div>
                            <div class="col-3">
                                <span class="input-group-text">Start</span>
                                <input type="text" placeholder="DD.MM.12:00(Uhrzeit)" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-sm">
                            </div>
                            <div class="col-3">
                                <span class="input-group-text">Ende</span>
                                <input type="text" placeholder="DD.MM.12:00(Uhrzeit)" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-sm">
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
                    <a class="btn btn-primary btn-block" href="#" role="button">Veranstaltung veröffentlichen</a>
                        <br>
                        <br>
                        <br>
                </div>
                </div>
            </div>
    </div>
</div>
</div>
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
</body>
</html>
