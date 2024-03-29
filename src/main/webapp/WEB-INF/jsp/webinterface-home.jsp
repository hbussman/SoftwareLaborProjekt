<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--@elvariable id="sponsor" type="sponsoren.orm.SponsorEntity"--%>
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

    <title>Persönliche Seite - Sponsoren</title>

    <style>
        input:invalid {
            background-color: tomato;
        }
    </style>

    <script>

        function Save() {

            var sponsor_beschreibung = document.getElementById("sponsor_beschreibung");
            var sponsor_werbetext = document.getElementById("sponsor_werbetext");
            var sponsor_adresse = document.getElementById("sponsor_adresse");
            var sponsor_nachname = document.getElementById("sponsor_nachname");
            var sponsor_vorname = document.getElementById("sponsor_vorname");
            var sponsor_email = document.getElementById("sponsor_email");
            var sponsor_telefonnummer = document.getElementById("sponsor_telefonnummer");
            var sponsor_homepage = document.getElementById("sponsor_homepage");
            var sponsor_plz = document.getElementById("sponsor_plz");
            var sponsor_ort = document.getElementById("sponsor_ort");
            var sponsor_postfach = document.getElementById("sponsor_postfach");

            var SponsorData = {
                name: document.getElementById("sponsor_name").innerText,
                beschreibung: sponsor_beschreibung.value,
                werbetext: sponsor_werbetext.value,
                adresse: sponsor_adresse.value,
                ansprechpartnerNachname: sponsor_nachname.value,
                ansprechpartnerVorname: sponsor_vorname.value,
                email: sponsor_email.value,
                telefonnummer: sponsor_telefonnummer.value,
                homepage: sponsor_homepage.value,
                plz: sponsor_plz.value,
                ort: sponsor_ort.value,
                postfach: sponsor_postfach.value
            };
            console.log("Save " + SponsorData);

            db_save_sponsor_info(SponsorData).then(function (result) {
                console.log(result.status);
                var resultElement = document.getElementById("ResultStatus");
                if (result.status == 200) {
                    resultElement.style.color = "darkgreen";
                    resultElement.innerText = "Änderungen erfolgreich gespeichert!"
                } else {
                    resultElement.style.color = "red";
                    result.text().then(value => {
                        resultElement.innerText = "Es ist ein Fehler aufgetreten: " + result.status + " (" + value + ")";
                    });
                }
            })
        }


        function changeLogo() {

            var formData = new FormData(document.getElementById("logo-form"));

            fetch("${context}/webinterface/image_upload", {

                body: formData,
                method: "POST"

            }).then(result => {

                var resultElem = document.getElementById('change-logo-result');

                if (result.ok) {
                    // successful
                    resultElem.style = "color:darkgreen;";
                    resultElem.innerText = "Bild erfolgreich geändert!";

                    // reload image
                    var oldImage = document.getElementById('sponsor-logo');
                    var newImage = new Image();
                    newImage.src = oldImage.src + "?_=" + Math.random();
                    newImage.style = "max-height: 250px; max-width: 250px";

                    oldImage.parentNode.insertBefore(newImage, oldImage);
                    oldImage.parentNode.removeChild(oldImage);
                } else {
                    // error
                    result.text().then(error => {
                        resultElem.style = "color:red;";
                        resultElem.innerText = "Fehler beim Upload: " + error;
                    });
                }
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
        <a id="Sponsorenseitebutton" class="btn btn-light disabled" href="${context}/webinterface"
           role="button" aria-disabled="true">Sponsorenseite
        </a>
    </div>
    <div class="pr-2">
        <a id="Accountbutton" class="btn btn-light" href="${context}/webinterface/account"
           role="button">Account
        </a>
    </div>
    <ul class="nav navbar-nav ml-auto">
    </ul>
    <p class="navbar-text navbar-center text-white" style="font-size: x-large">${sponsor.name} Sponsorenseite</p>
    <div class="pr-2">
        <a id="Attraktionsbutton" class="btn btn-light" href="${context}/webinterface/attractions"
           role="button">Attraktionen
        </a>
        <a id="Veranstaltungsbutton" class="btn btn-light" href="${context}/webinterface/events"
           role="button">Veranstaltungen
        </a>
    </div>
    <a id="logoutbutton" class="btn btn-danger" href="${context}/logout" role="button"><i
            class="fa fa-sign-out-alt"></i>
    </a>
</nav>
<div class="container pt-5">
    <div class="row">
        <div class="col-12">
            <div class="card">

                <!-- Sponsor Logo -->
                <div class="text-center">
                    <img id="sponsor-logo" src="${context}/image/${sponsor.name}_scaled.png"
                         style="max-height: 250px; max-width: 250px"
                         class="card-img-thumbnail" alt="...">
                </div>

                <!-- Logo Bild ändern Upload -->
                <div class="text-center">
                    <form id="logo-form" enctype="multipart/form-data">
                        <input type="file" name="uploadedFileName" id="fileToUpload" accept="image/png">
                        <label for="fileToUpload"> Neues Logo auswählen</label>
                        <input type="button" value="Abschicken" onclick="changeLogo();">
                    </form>
                    <p id="change-logo-result"></p>
                </div>

                <!-- Sponsor Name und Beschreibung -->
                <div class="card-body">
                    <h5 id="sponsor_name" class="card-title">${sponsor.name}</h5>
                    <textarea id="sponsor_beschreibung" class="form-control" rows="8"
                              placeholder="Sponsoren Info-Text" aria-label="Username"
                              aria-describedby="basic-addon1">${sponsor.beschreibung}</textarea>
                </div>

                <!-- Werbetext -->
                <div class="card-body">
                    <h5 class="card-title">Rolle bei der Buga</h5>
                    <textarea id="sponsor_werbetext" class="form-control" rows="5"
                              placeholder="Sponsoren Info-Text" aria-label="Username"
                              aria-describedby="basic-addon1">${sponsor.werbetext}</textarea>
                </div>
                <div class="card-body">
                    <h5 class="card-title">Kontakt</h5>
                    <div class="row">
                        <div class="col-4">
                            <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text">Name</span>
                            </div>
                                <input id="sponsor_nachname" type="text"
                                       value="${sponsor.ansprechpartnerNachname}" class="form-control"
                                       aria-label="Sizing example input"
                                       aria-describedby="inputGroup-sizing-sm">
                            </div>
                            <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text">Vorname</span>
                            </div>
                                <input id="sponsor_vorname" type="text"
                                       value="${sponsor.ansprechpartnerVorname}" class="form-control"
                                       aria-label="Sizing example input"
                                       aria-describedby="inputGroup-sizing-sm">
                            </div>
                        </div>
                        <div class="col-4">
                            <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text">Email</span>
                            </div>
                                <input id="sponsor_email" type="email" value="${sponsor.email}"
                                       class="form-control" aria-label="Sizing example input"
                                       aria-describedby="inputGroup-sizing-sm">
                            </div>
                            <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text">Telefon</span>
                            </div>
                                <input id="sponsor_telefonnummer" type="tel"
                                       value="${sponsor.telefonnummer}" class="form-control"
                                       aria-label="Sizing example input"
                                       aria-describedby="inputGroup-sizing-sm">
                            </div>
                            <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text">Homepage</span>
                            </div>
                                <input id="sponsor_homepage" type="text" value="${sponsor.homepage}"
                                       class="form-control" aria-label="Sizing example input"
                                       aria-describedby="inputGroup-sizing-sm">
                            </div>
                        </div>
                        <div class="col-4">
                            <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text">Plz</span>
                            </div>
                                <input id="sponsor_plz" type="text" value="${sponsor.plz}"
                                       class="form-control" aria-label="Sizing example input"
                                       aria-describedby="inputGroup-sizing-sm">
                            </div>
                            <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text">Ort</span>
                            </div>
                                <input id="sponsor_ort" type="text" value="${sponsor.ort}"
                                       class="form-control" aria-label="Sizing example input"
                                       aria-describedby="inputGroup-sizing-sm">
                            </div>
                            <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text">Adresse</span>
                            </div>
                                <input id="sponsor_adresse" type="tel"
                                       value="${sponsor.adresse}" class="form-control"
                                       aria-label="Sizing example input"
                                       aria-describedby="inputGroup-sizing-sm">
                            </div>
                            <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text">Postfach</span>
                            </div>
                                <input id="sponsor_postfach" type="tel"
                                       value="${sponsor.postfach}" class="form-control"
                                       aria-label="Sizing example input"
                                       aria-describedby="inputGroup-sizing-sm">
                            </div>
                        </div>
                    </div>
                </div>

                <br>

                <div class="row">
                    <div class="col" align="center"> <br> <p style="font-size: xx-large" id="ResultStatus"></p>
                    </div>
                </div>

                <br>


                <button id="submit" class="btn btn-primary btn-block" onclick="Save()" role="button">Änderungen
                    speichern
                </button>



                <div class="card-body">
                    <h5 id="aufruf" class="card-title">Aufrufstatistik</h5>
                    Ihre Sponsorseite wurde seit Ihrer letzten Änderung ${sponsor.aufrufe}x aufgerufen!
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
