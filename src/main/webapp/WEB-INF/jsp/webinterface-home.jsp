<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--@elvariable id="sponsor" type="sponsoren.orm.SponsorEntity"--%>
<c:set var="context" value="${pageContext.request.contextPath}" />

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

    <title>Persönliche Seite - Sponsoren</title>

    <script>
        var username;

        function Init() {
            username = getCookie("username");
        }

        function Save() {

            var sponsor_beschreibung = document.getElementById("sponsor_beschreibung");
            var sponsor_werbetext = document.getElementById("sponsor_werbetext");
            var sponsor_adresse = document.getElementById("sponsor_adresse");
            var sponsor_nachname = document.getElementById("sponsor_nachname");
            var sponsor_vorname = document.getElementById("sponsor_vorname");
            var sponsor_email = document.getElementById("sponsor_email");
            var sponsor_telefonnummer = document.getElementById("sponsor_telefonnummer");
            var sponsor_homepage = document.getElementById("sponsor_homepage");

            var SponsorData = {
                name: username,
                beschreibung: sponsor_beschreibung.value || sponsor_beschreibung.placeholder,
                werbetext: sponsor_werbetext.value || sponsor_werbetext.placeholder,
                adresse: sponsor_adresse.value || sponsor_adresse.placeholder,
                ansprechpartnerNachname: sponsor_nachname.value || sponsor_nachname.placeholder,
                ansprechpartnerVorname: sponsor_vorname.value || sponsor_vorname.placeholder,
                email: sponsor_email.value || sponsor_email.placeholder,
                telefonnummer: sponsor_telefonnummer.value || sponsor_telefonnummer.placeholder,
                homepage: sponsor_homepage.value || sponsor_homepage.placeholder
            };
            console.log("Save " + SponsorData);

            db_save_sponsor_info(SponsorData).then(function (value) {
                console.log(value.status);
                var result = document.getElementById("ResultStatus");
                if (value.status == 200) {
                    result.style.color = "darkgreen";
                    result.innerText = "Änderungen erfolgreich gespeichert!";

                    sponsor_adresse.placeholder = SponsorData.adresse;
                    sponsor_adresse.value = "";

                    sponsor_nachname.placeholder = SponsorData.ansprechpartnerNachname;
                    sponsor_nachname.value = "";

                    sponsor_vorname.placeholder = SponsorData.ansprechpartnerVorname;
                    sponsor_vorname.value = "";

                    sponsor_email.placeholder = SponsorData.email;
                    sponsor_email.value = "";

                    sponsor_telefonnummer.placeholder = SponsorData.telefonnummer;
                    sponsor_telefonnummer.value = "";

                    sponsor_homepage.placeholder = SponsorData.homepage;
                    sponsor_homepage.value = "";


                } else {
                    result.style.color = "red";
                    result.innerText = "Es ist ein Fehler aufgetreten";
                }
            })
        }
    </script>

</head>
<body onload="Init()">
<nav class="navbar navbar-expand-lg navbar-dark bg-dark justify-content-center">
    <a class="navbar-brand" style="color: whitesmoke">Sponsoren-Webinterface</a>
    <ul class="nav navbar-nav ml-auto">
    </ul>
    <div class="pr-2">
        <a class="btn btn-primary btn-secondary" href="${context}/webinterface/events?sponsor=${sponsor.name}" role="button">Veranstaltungen
        </a>
    </div>
    <a class="btn btn-primary btn-danger" href="${context}/webinterface/login" role="button"><i class="fa fa-sign-out-alt"></i>
    </a>
</nav>
<div class="container">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="text-center">
                    <img src="${context}/img/${sponsor.name}_scaled.png" style="max-height: 250px; max-width: 250px"
                         class="card-img-thumbnail" alt="...">
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
                <div class="col-12">
                    <div class="text-center">
                    </div>
                    <div class="card-body">
                        <h5 class="card-title">Kontakt</h5>
                        <div class="input-group input-group-sm mb-3">
                            <div class="row">
                                <div class="col-6">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text">Name</span>
                                        <input id="sponsor_nachname" type="text"
                                               placeholder="${sponsor.ansprechpartnerNachname}" class="form-control"
                                               aria-label="Sizing example input"
                                               aria-describedby="inputGroup-sizing-sm">
                                    </div>
                                </div>
                                <div class="col-6">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text">Vorname</span>
                                        <input id="sponsor_vorname" type="text"
                                               placeholder="${sponsor.ansprechpartnerVorname}" class="form-control"
                                               aria-label="Sizing example input"
                                               aria-describedby="inputGroup-sizing-sm">
                                    </div>

                                </div>
                            </div>
                        </div>

                        <div class="input-group input-group-sm mb-3">
                            <div class="row">
                                <div class="col-6">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text">Email</span>
                                        <input id="sponsor_email" type="email" placeholder="${sponsor.email}"
                                               class="form-control" aria-label="Sizing example input"
                                               aria-describedby="inputGroup-sizing-sm">
                                    </div>
                                </div>
                                <div class="col-6">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text">Telefonnummer</span>
                                        <input id="sponsor_telefonnummer" type="tel"
                                               placeholder="${sponsor.telefonnummer}" class="form-control"
                                               aria-label="Sizing example input"
                                               aria-describedby="inputGroup-sizing-sm">
                                    </div>
                                </div>

                            </div>
                        </div>


                        <div class="input-group input-group-sm mb-3">
                            <div class="row">
                                <div class="col-6">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text">Homepage</span>
                                        <input id="sponsor_homepage" type="text" placeholder="${sponsor.homepage}"
                                               class="form-control" aria-label="Sizing example input"
                                               aria-describedby="inputGroup-sizing-sm">
                                    </div>
                                </div>


                                <div class="col-6">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text">Adresse</span>
                                        <input id="sponsor_adresse" type="text" placeholder="${sponsor.adresse}"
                                               class="form-control" aria-label="Sizing example input"
                                               aria-describedby="inputGroup-sizing-sm">
                                    </div>
                                </div>
                            </div>
                        </div>


                        <button id=submit" class="btn btn-primary btn-block" onclick="Save()" role="button">Änderungen
                            speichern</button>
                        <br>
                        <p id="ResultStatus"></p>
                        <br>
                    </div>
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
